import {
  createSolidTable,
  getCoreRowModel,
  RowSelectionState,
} from '@tanstack/solid-table'
import { createSignal } from 'solid-js'

import { UseDataTableProps } from '~/hooks/table/useDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'

type PaginationData = ReturnType<typeof useDataTablePagination>

// eslint-disable-next-line max-lines-per-function
export const useSelectableDataTable = <TData, TValue>(
  params: UseDataTableProps<TData, TValue>,
  paginationData: PaginationData,
) => {
  const [rowSelection, setRowSelection] = createSignal<RowSelectionState>({})

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
    enableRowSelection: true,
    onRowSelectionChange: (updater) => {
      setRowSelection((current) =>
        typeof updater === 'function' ? updater(current) : updater,
      )
    },
    getCoreRowModel: getCoreRowModel(),

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
