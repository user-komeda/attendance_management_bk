import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

export const usePagination = () => {
  const { fetchWorkspaces } = useHomeWorkspaces()

  const handlePageChange = async (page: number, perPage: number) => {
    await fetchWorkspaces({ page, perPage })
  }

  const handlePageSizeChange = async (perPage: number) => {
    await fetchWorkspaces({ page: 1, perPage: perPage })
  }

  return {
    handlePageChange,
    handlePageSizeChange,
  }
}
