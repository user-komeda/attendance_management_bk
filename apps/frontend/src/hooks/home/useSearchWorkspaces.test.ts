import { renderHook } from '@solidjs/testing-library'
import { createRoot, createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'
import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

describe('useSearchWorkspaces', () => {
  it('keywordが初期化されること', async () => {
    const workspaces = createSignal({ meta: { searchQuery: 'initial' } })[0]
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces: vi.fn(),
      workspaces,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useSearchWorkspaces())

      await new Promise((resolve) => setTimeout(resolve, 10))

      expect(result.keyword()).toBe('initial')
      dispose()
    })
  })

  it('handleSearchが正しく動作すること', async () => {
    const fetchWorkspaces = vi.fn()
    const workspaces = createSignal({ meta: { searchQuery: '' } })[0]
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
      workspaces,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useSearchWorkspaces())
      result.setKeyword('  new search  ')

      await result.handleSearch()

      expect(fetchWorkspaces).toHaveBeenCalledWith({
        searchQuery: 'new search',
        page: 1,
      })
      expect(result.isSearching()).toBe(false)
      dispose()
    })
  })
})
