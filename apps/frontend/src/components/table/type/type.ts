import { ColumnDef } from '@tanstack/solid-table'

import { useDataTable } from '~/hooks/table/useDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'

export type PaginationSelectProps = Pick<
  PaginationProps,
  'pagination' | 'handlePageSizeChange'
>

export type PaginationButtonsProps = Omit<
  PaginationProps,
  'handlePageSizeChange'
>

export type PaginationProps = ReturnType<typeof useDataTablePagination>
export interface DataTableProps<TData, TValue> {
  table: ReturnType<typeof useDataTable<TData, TValue>>['table']
  columns: ColumnDef<TData, TValue>[]
  paginationData: PaginationProps
  getRowHref?: (row: TData) => string
}
