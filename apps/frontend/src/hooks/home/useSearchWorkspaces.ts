import { createEffect, createSignal } from 'solid-js'

import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

const DEFAULT_PAGE = 1

export const useSearchWorkspaces = () => {
  const { fetchWorkspaces, workspaces } = useHomeWorkspaces()

  const [keyword, setKeyword] = createSignal('')
  const [isSearching, setIsSearching] = createSignal(false)

  createEffect(() => {
    setKeyword(workspaces()?.meta.searchQuery ?? '')
  })

  const handleSearch = async () => {
    setIsSearching(true)

    try {
      await fetchWorkspaces({
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
