import { useWorkspace } from '~/provider/workspacesProvider'

export const usePagination = () => {
  const { refetchWorkspaces, workspaces } = useWorkspace()

  const currentSearchQuery = () => {
    const searchQuery = workspaces()?.meta.searchQuery?.trim()

    return searchQuery ? searchQuery : undefined
  }

  const handlePageChange = async (page: number, perPage: number) => {
    await refetchWorkspaces({
      page,
      perPage,
      searchQuery: currentSearchQuery(),
    })
  }

  const handlePageSizeChange = async (perPage: number) => {
    await refetchWorkspaces({
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
