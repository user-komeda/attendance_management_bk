import { ColumnDef, flexRender, HeaderGroup } from '@tanstack/solid-table'
import { For, Show } from 'solid-js'

import { PaginationArea } from '~/components/table/paginationArea'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '~/components/ui/table'
import { DataTableProps, useDataTable } from '~/hooks/useDataTable'
import type { useDataTablePagination } from '~/hooks/useDataTablePagination'

export type PaginationProps = ReturnType<typeof useDataTablePagination>

const TableHeadersContent = <TData,>(props: {
  headers: HeaderGroup<TData>[]
}) => {
  const { headers } = props
  return (
    <For each={headers}>
      {(headerGroup) => (
        <TableRow>
          <For each={headerGroup.headers}>
            {(header) => (
              <TableHead colSpan={header.colSpan}>
                <Show when={!header.isPlaceholder}>
                  {flexRender(
                    header.column.columnDef.header,
                    header.getContext(),
                  )}
                </Show>
              </TableHead>
            )}
          </For>
        </TableRow>
      )}
    </For>
  )
}

const TableBodyContent = <TData, TValue>(props: {
  table: ReturnType<typeof useDataTable<TData, TValue>>['table']
  columns: ColumnDef<TData, TValue>[]
}) => {
  return (
    <Show
      when={props.table.getRowModel().rows.length}
      fallback={
        <TableRow>
          <TableCell colSpan={props.columns.length} class="h-24 text-center">
            No results.
          </TableCell>
        </TableRow>
      }
    >
      <For each={props.table.getRowModel().rows}>
        {(row) => (
          <TableRow
            data-state={
              row.getIsSelected && row.getIsSelected() ? 'selected' : undefined
            }
          >
            <For each={row.getVisibleCells()}>
              {(cell) => (
                <TableCell>
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </TableCell>
              )}
            </For>
          </TableRow>
        )}
      </For>
    </Show>
  )
}

export function BasicDataTable<TData, TValue>(
  props: DataTableProps<TData, TValue>,
) {
  const { table, ...paginationData } = useDataTable({
    get columns() {
      return props.columns
    },
    get data() {
      return props.data
    },
    get paginationMeta() {
      return props.paginationMeta
    },
    onPageChange: props.onPageChange,
    onPageSizeChange: props.onPageSizeChange,
  })

  return (
    <div class="space-y-4">
      <div class="rounded-md border">
        <Table>
          <TableHeader>
            <TableHeadersContent<TData> headers={table.getHeaderGroups()} />
          </TableHeader>

          <TableBody>
            <TableBodyContent table={table} columns={props.columns} />
          </TableBody>
        </Table>
      </div>
      <PaginationArea {...paginationData} />
    </div>
  )
}
