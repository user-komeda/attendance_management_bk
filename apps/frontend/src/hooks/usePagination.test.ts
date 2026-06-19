import { renderHook } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { usePagination } from '~/hooks/usePagination'
import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

describe('usePagination', () => {
  it('handlePageChangeが正しく動作すること', async () => {
    const fetchWorkspaces = vi.fn()
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageChange(2, 10)

    expect(fetchWorkspaces).toHaveBeenCalledWith({ page: 2, perPage: 10 })
  })

  it('handlePageSizeChangeが正しく動作すること', async () => {
    const fetchWorkspaces = vi.fn()
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => usePagination())
    await result.handlePageSizeChange(20)

    expect(fetchWorkspaces).toHaveBeenCalledWith({ page: 1, perPage: 20 })
  })
})
