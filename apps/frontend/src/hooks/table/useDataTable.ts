import { ColumnDef, RowData, TableFeatures } from '@tanstack/solid-table'

import { useBaseDataTable } from '~/hooks/table/useBaseDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'
import { useSelectableDataTable } from '~/hooks/table/useSelectableDataTable'
import { PaginationMeta } from '~/schema/api/paginationMetas'

type OmitPaginationMeta = Omit<PaginationMeta, 'searchQuery'>

export interface UseDataTableProps<TData extends RowData> {
  columns: ColumnDef<TableFeatures, TData, unknown>[]
  data: TData[]
  paginationMeta: OmitPaginationMeta
  onPageChange: (page: number, perPage: number) => void
  onPageSizeChange: (pageSize: number) => void
  selectable?: boolean
}

export const useDataTable = <TData extends RowData>(
  params: UseDataTableProps<TData>,
) => {
  const paginationData = useDataTablePagination({
    paginationMeta: () => params.paginationMeta,
    onPageChange: params.onPageChange,
    onPageSizeChange: params.onPageSizeChange,
  })

  const tableData:
    | ReturnType<typeof useBaseDataTable<TData>>
    | ReturnType<typeof useSelectableDataTable<TData>> = params.selectable
    ? useSelectableDataTable(params, paginationData)
    : useBaseDataTable(params, paginationData)

  return {
    ...tableData,
    ...paginationData,
  }
}
