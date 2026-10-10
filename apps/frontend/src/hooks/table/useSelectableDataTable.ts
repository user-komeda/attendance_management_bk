import {
  createTable,
  RowData,
  RowSelectionState,
  SolidTable,
  stockFeatures,
  TableFeatures,
  tableFeatures,
  Updater,
} from '@tanstack/solid-table'
import { createSignal } from 'solid-js'

import { UseDataTableProps } from '~/hooks/table/useDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'

type PaginationData = ReturnType<typeof useDataTablePagination>

export const useSelectableDataTable = <TData extends RowData>(
  params: UseDataTableProps<TData>,
  paginationData: PaginationData,
): {
  table: SolidTable<TableFeatures, TData>
  rowSelection: () => RowSelectionState
  // eslint-disable-next-line max-lines-per-function
} => {
  const [rowSelection, setRowSelection] = createSignal<RowSelectionState>({})

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
    enableRowSelection: true,
    onRowSelectionChange: (updater: Updater<RowSelectionState>) => {
      setRowSelection((current) =>
        typeof updater === 'function' ? updater(current) : updater,
      )
    },
    get state() {
      return {
        pagination: paginationData.pagination(),
        rowSelection: rowSelection(),
      }
    },
  })

  return {
    table,
    rowSelection,
  }
}
