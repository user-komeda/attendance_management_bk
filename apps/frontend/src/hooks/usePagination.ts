import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

export const usePagination = () => {
  const { fetchWorkspaces, workspaces } = useHomeWorkspaces()

  const currentSearchQuery = () => {
    const searchQuery = workspaces()?.meta.searchQuery?.trim()

    return searchQuery ? searchQuery : undefined
  }

  const handlePageChange = async (page: number, perPage: number) => {
    await fetchWorkspaces({
      page,
      perPage,
      searchQuery: currentSearchQuery(),
    })
  }

  const handlePageSizeChange = async (perPage: number) => {
    await fetchWorkspaces({
      page: 1,
      perPage,
      searchQuery: currentSearchQuery(),
    })
  }

  return {
    handlePageChange,
    handlePageSizeChange,
  }
}
