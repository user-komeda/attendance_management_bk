import { ColumnDef } from '@tanstack/solid-table'

import { useBaseDataTable } from '~/hooks/table/useBaseDataTable'
import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'
import { useSelectableDataTable } from '~/hooks/table/useSelectableDataTable'
import { PaginationMeta } from '~/schema/api/paginationMetas'

type OmitPaginationMeta = Omit<PaginationMeta, 'searchQuery'>

export interface UseDataTableProps<TData, TValue> {
  columns: ColumnDef<TData, TValue>[]
  data: TData[]
  paginationMeta: OmitPaginationMeta
  onPageChange: (page: number, perPage: number) => void
  onPageSizeChange: (pageSize: number) => void
  selectable?: boolean
}

export const useDataTable = <TData, TValue>(
  params: UseDataTableProps<TData, TValue>,
) => {
  const paginationData = useDataTablePagination({
    paginationMeta: () => params.paginationMeta,
    onPageChange: params.onPageChange,
    onPageSizeChange: params.onPageSizeChange,
  })

  const tableData = params.selectable
    ? useSelectableDataTable(params, paginationData)
    : useBaseDataTable(params, paginationData)

  return {
    ...tableData,
    ...paginationData,
  }
}
