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
})
