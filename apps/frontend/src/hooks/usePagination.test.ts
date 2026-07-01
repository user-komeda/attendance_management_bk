import { renderHook } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { usePagination } from '~/hooks/usePagination'
import { useWorkspace } from '~/provider/workspacesProvider'

vi.mock('~/provider/workspacesProvider', () => ({
  useWorkspace: vi.fn(),
}))

 
describe('usePagination', () => {
  it('handlePageChangeが正しく動作すること', async () => {
    const refetchWorkspaces = vi.fn()
    const workspaces = vi.fn().mockReturnValue({
      meta: { searchQuery: '' },
    })
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces,
    } as unknown as ReturnType<typeof useWorkspace>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageChange(2, 10)

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      page: 2,
      perPage: 10,
      searchQuery: undefined,
    })
  })

  it('handlePageSizeChangeが正しく動作すること', async () => {
    const refetchWorkspaces = vi.fn()
    const workspaces = vi.fn().mockReturnValue({
      meta: { searchQuery: '' },
    })
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces,
    } as unknown as ReturnType<typeof useWorkspace>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageSizeChange(20)

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      page: 1,
      perPage: 20,
      searchQuery: undefined,
    })
  })

  it('searchQueryがある場合に正しく動作すること', async () => {
    const refetchWorkspaces = vi.fn()
    const workspaces = vi.fn().mockReturnValue({
      meta: { searchQuery: ' test ' },
    })
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces,
    } as unknown as ReturnType<typeof useWorkspace>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageChange(2, 10)

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      page: 2,
      perPage: 10,
      searchQuery: 'test',
    })
  })

  it('searchQueryがトリミング後に空になる場合にundefinedを返すこと', async () => {
    const refetchWorkspaces = vi.fn()
    const workspaces = vi.fn().mockReturnValue({
      meta: { searchQuery: '   ' },
    })
    vi.mocked(useWorkspace).mockReturnValue({
      refetchWorkspaces,
      workspaces,
    } as unknown as ReturnType<typeof useWorkspace>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageChange(1, 10)

    expect(refetchWorkspaces).toHaveBeenCalledWith({
      page: 1,
      perPage: 10,
      searchQuery: undefined,
    })
  })
})
