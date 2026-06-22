import {
  ColumnDef,
  createSolidTable,
  getCoreRowModel,
} from '@tanstack/solid-table'

import { useDataTablePagination } from '~/hooks/useDataTablePagination'
import { PaginationMeta } from '~/schema/api/paginationMetas'

type OmitPaginationMeta = Omit<PaginationMeta, 'searchQuery'>

export interface DataTableProps<TData, TValue> {
  columns: ColumnDef<TData, TValue>[]
  data: TData[]
  paginationMeta: OmitPaginationMeta
  onPageChange: (page: number, perPage: number) => void
  onPageSizeChange: (pageSize: number) => void
}

export const useDataTable = <TData, TValue>(
  params: DataTableProps<TData, TValue>,
) => {
  const paginationData = useDataTablePagination({
    paginationMeta: () => params.paginationMeta,
    onPageChange: params.onPageChange,
    onPageSizeChange: params.onPageSizeChange,
  })

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
    ...paginationData,
  }
}
