import { useNavigate } from '@solidjs/router'
import { ColumnDef, flexRender, HeaderGroup } from '@tanstack/solid-table'
import { For, Show } from 'solid-js'

import { FailbackTable } from '~/components/table/failbackTable'
import { PaginationArea } from '~/components/table/paginationArea'
import { DataTableProps } from '~/components/table/type/type'
import { navigateRow } from '~/components/table/util/navigateRow'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '~/components/ui/table'
import { useDataTable } from '~/hooks/table/useDataTable'

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
  getRowHref?: (row: TData) => string
}) => {
  const navigate = useNavigate()

  return (
    <Show
      when={props.table.getRowModel().rows.length}
      fallback={<FailbackTable length={props.columns.length} />}
    >
      <For each={props.table.getRowModel().rows}>
        {(row) => {
          const href = () => props.getRowHref?.(row.original)

          return (
            <TableRow
              data-state={row.getIsSelected() ? 'selected' : undefined}
              class={props.getRowHref ? 'cursor-pointer' : undefined}
              onClick={() => {
                navigateRow(navigate, href)
              }}
            >
              <For each={row.getVisibleCells()}>
                {(cell) => (
                  <TableCell>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                )}
              </For>
            </TableRow>
          )
        }}
      </For>
    </Show>
  )
}

export function BasicDataTable<TData, TValue>(
  props: DataTableProps<TData, TValue>,
) {
  return (
    <div class="space-y-4">
      <div class="rounded-md border">
        <Table>
          <TableHeader>
            <TableHeadersContent<TData>
              headers={props.table.getHeaderGroups()}
            />
          </TableHeader>

          <TableBody>
            <TableBodyContent
              table={props.table}
              columns={props.columns}
              getRowHref={props.getRowHref}
            />
          </TableBody>
        </Table>
      </div>
      <PaginationArea {...props.paginationData} />
    </div>
  )
}
