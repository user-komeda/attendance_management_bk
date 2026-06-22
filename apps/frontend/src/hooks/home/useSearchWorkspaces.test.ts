import { renderHook, waitFor } from '@solidjs/testing-library'
import { createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'
import {
  useHomeWorkspaces,
  type HomeWorkspacesContextValue,
} from '~/provider/homeWorkspacesProvider'
import { type ListWorkSpacesResponse } from '~/schema/api/workSpaces'

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

// eslint-disable-next-line max-lines-per-function
describe('useSearchWorkspaces', () => {
  it('updates keyword when workspaces meta changes', async () => {
    const fetchWorkspaces = vi.fn()
    const [workspaces, setWorkspaces] = createSignal<
      Partial<ListWorkSpacesResponse>
    >({
      meta: {
        searchQuery: 'initial',
        page: 1,
        totalPages: 1,
        totalCount: 1,
        perPage: 10,
      },
    })

    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
      workspaces,
    } as unknown as HomeWorkspacesContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    expect(result.keyword()).toBe('initial')

    setWorkspaces({
      meta: {
        searchQuery: 'updated',
        page: 1,
        totalPages: 1,
        totalCount: 1,
        perPage: 10,
      },
    })
    await waitFor(() => expect(result.keyword()).toBe('updated'))
  })

  it('calls fetchWorkspaces with keyword on handleSearch', async () => {
    const fetchWorkspaces = vi.fn().mockResolvedValue(undefined)
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as HomeWorkspacesContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    result.setKeyword('  new search  ')
    await result.handleSearch()

    expect(fetchWorkspaces).toHaveBeenCalledWith({
      searchQuery: 'new search',
      page: 1,
    })
  })

  it('キーワードが空の場合は空文字で検索すること', async () => {
    const fetchWorkspaces = vi.fn().mockResolvedValue(undefined)
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as HomeWorkspacesContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    result.setKeyword('   ')
    await result.handleSearch()

    expect(fetchWorkspaces).toHaveBeenCalledWith({
      searchQuery: '',
      page: 1,
    })
  })

  it('fetchWorkspacesが失敗した場合はエラーをスローすること', async () => {
    const fetchWorkspaces = vi.fn().mockRejectedValue(new Error('fetch error'))
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as HomeWorkspacesContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    await expect(result.handleSearch()).rejects.toThrow('fetch error')
  })
})
