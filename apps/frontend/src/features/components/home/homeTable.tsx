import { ColumnDef } from '@tanstack/solid-table'
import { Show } from 'solid-js'

import { BasicDataTable } from '~/components/table/BasicDataTable'
import { HomeTableHeader } from '~/features/components/home/homeTablePrevArea'
import { useDataTable } from '~/hooks/table/useDataTable'
import { usePagination } from '~/hooks/usePagination'
import { useWorkspace } from '~/provider/workspacesProvider'
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

const fallbackPaginationMeta = {
  page: 1,
  totalPages: 0,
  totalCount: 0,
  perPage: 10,
}

export const HomeTable = () => {
  const { workspaces } = useWorkspace()
  const { handlePageChange, handlePageSizeChange } = usePagination()

  const { table, ...paginationData } = useDataTable<
    WorkSpaceWithStatus,
    unknown
  >({
    get columns() {
      return columns
    },
    get data() {
      return workspaces()?.data ?? []
    },
    get paginationMeta() {
      return workspaces()?.meta ?? fallbackPaginationMeta
    },
    onPageChange: handlePageChange,
    onPageSizeChange: handlePageSizeChange,
  })

  return (
    <div>
      <HomeTableHeader />

      <Show when={workspaces()} fallback={<h1>Loading...</h1>}>
        <BasicDataTable
          table={table}
          columns={columns}
          paginationData={paginationData}
          getRowHref={(row) => `/workspaces/${row.slug}`}
        />
      </Show>
    </div>
  )
}
