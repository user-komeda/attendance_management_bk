import {
  createTable,
  RowData,
  SolidTable,
  stockFeatures,
  TableFeatures,
  tableFeatures,
} from '@tanstack/solid-table'

import { UseDataTableProps } from '~/hooks/table/useDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'

type PaginationData = ReturnType<typeof useDataTablePagination>

export const useBaseDataTable = <TData extends RowData>(
  params: UseDataTableProps<TData>,
  paginationData: PaginationData,
): { table: SolidTable<TableFeatures, TData> } => {
  const table = createTable<TableFeatures, TData>({
    features: tableFeatures(stockFeatures),
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
