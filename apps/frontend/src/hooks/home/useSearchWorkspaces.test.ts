import { renderHook, waitFor } from '@solidjs/testing-library'
import { createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'
import {
  useWorkspace,
  WorkspaceContextValue,
} from '~/provider/workspacesProvider'
import { type ListWorkSpacesResponse } from '~/schema/api/workSpaces'

vi.mock('~/provider/workspacesProvider', () => ({
  useWorkspace: vi.fn(),
}))

 
describe('useSearchWorkspaces', () => {
  it('updates keyword when contentApi meta changes', async () => {
    const refetchWorkspaces = vi.fn()
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

    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces,
    } as unknown as WorkspaceContextValue)

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

  it('calls refetchWorkspaces with keyword on handleSearch', async () => {
    const refetchWorkspaces = vi.fn().mockResolvedValue(undefined)
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as WorkspaceContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    result.setKeyword('  new search  ')
    await result.handleSearch()

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      searchQuery: 'new search',
      page: 1,
    })
  })

  it('キーワードが空の場合�E空斁E��で検索すること', async () => {
    const refetchWorkspaces = vi.fn().mockResolvedValue(undefined)
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as WorkspaceContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    result.setKeyword('   ')
    await result.handleSearch()

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      searchQuery: '',
      page: 1,
    })
  })

  it('refetchWorkspacesが失敗した場合�Eエラーをスローすること', async () => {
    const refetchWorkspaces = vi
      .fn()
      .mockRejectedValue(new Error('fetch error'))
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces: () =>
        ({ meta: { searchQuery: '' } }) as ListWorkSpacesResponse,
    } as unknown as WorkspaceContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    await expect(result.handleSearch()).rejects.toThrow('fetch error')
  })

  it('workspacesがundefinedの場合はkeywordが空文字になること', async () => {
    const refetchWorkspaces = vi.fn()
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces: () => undefined,
    } as unknown as WorkspaceContextValue)

    const { result } = renderHook(() => useSearchWorkspaces())

    expect(result.keyword()).toBe('')
  })
})
