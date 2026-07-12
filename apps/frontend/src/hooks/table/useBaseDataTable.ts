import { createSolidTable, getCoreRowModel } from '@tanstack/solid-table'

import { UseDataTableProps } from '~/hooks/table/useDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'

type PaginationData = ReturnType<typeof useDataTablePagination>

export const useBaseDataTable = <TData, TValue>(
  params: UseDataTableProps<TData, TValue>,
  paginationData: PaginationData,
) => {
  const table = createSolidTable({
    get data() {
      return params.data
    },
    get columns() {
      return params.columns
    },
    get rowCount() {
      return params.paginationMeta.totalCount ?? 0
    },
    get pageCount() {
      return paginationData.pageCount()
    },
    manualPagination: true,
    getCoreRowModel: getCoreRowModel(),

    get state() {
      return {
        pagination: paginationData.pagination(),
      }
    },
  })

  return {
    table,
  }
}
