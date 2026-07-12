import { createEffect, createSignal } from 'solid-js'

import { useWorkspace } from '~/provider/workspacesProvider'

const DEFAULT_PAGE = 1

export const useSearchWorkspaces = () => {
  const { refetchWorkspaces, workspaces } = useWorkspace()

  const [keyword, setKeyword] = createSignal('')
  const [isSearching, setIsSearching] = createSignal(false)

  createEffect(() => {
    setKeyword(workspaces()?.meta.searchQuery ?? '')
  })

  const handleSearch = async () => {
    setIsSearching(true)

    try {
      await refetchWorkspaces({
        searchQuery: keyword().trim(),
        page: DEFAULT_PAGE,
      })
    } finally {
      setIsSearching(false)
    }
  }

  return {
    keyword,
    setKeyword,
    isSearching,
    handleSearch,
  }
}
