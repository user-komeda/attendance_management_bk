import { ColumnDef } from '@tanstack/solid-table'
import { Show } from 'solid-js'

import { BasicDataTable } from '~/components/BasicDataTable'
import { HomeTableHeader } from '~/features/components/home/homeTableHeader'
import { usePagination } from '~/hooks/usePagination'
import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'
import { WorkSpaceWithStatus } from '~/schema/api/workSpaces'

const columns: ColumnDef<WorkSpaceWithStatus>[] = [
  {
    accessorKey: 'name',
    header: 'ワークスペース名',
  },
  {
    accessorKey: 'slug',
    header: 'サービスID',
  },
  {
    accessorKey: 'status',
    header: 'ステータス',
  },
]

export const HomeTable = () => {
  const { workspaces } = useHomeWorkspaces()
  const { handlePageChange, handlePageSizeChange } = usePagination()

  return (
    <div>
      <HomeTableHeader />

      <Show when={workspaces()} fallback={<h1>Loading...</h1>}>
        <BasicDataTable
          data={workspaces()?.data ?? []}
          columns={columns}
          paginationMeta={
            workspaces()?.meta ?? {
              page: 1,
              totalPages: 0,
              totalCount: 0,
              perPage: 10,
            }
          }
          onPageChange={handlePageChange}
          onPageSizeChange={handlePageSizeChange}
        />
      </Show>
    </div>
  )
}
