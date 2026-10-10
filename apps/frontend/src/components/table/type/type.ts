import { ColumnDef, RowData, TableFeatures } from '@tanstack/solid-table'

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
export interface DataTableProps<TData extends RowData> {
  table: ReturnType<typeof useDataTable<TData>>['table']
  columns: ColumnDef<TableFeatures, TData, unknown>[]
  paginationData: PaginationProps
  getRowHref?: (row: TData) => string
}
