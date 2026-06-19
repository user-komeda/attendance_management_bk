import {
  ColumnDef,
  createSolidTable,
  flexRender,
  getCoreRowModel,
} from '@tanstack/solid-table'
import { For, Show } from 'solid-js'

import { Button } from '~/components/ui/button'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '~/components/ui/table'
import { useDataTablePagination } from '~/hooks/useDataTablePagination'
import { PaginationMeta } from '~/schema/api/paginationMetas'

type OmitPaginationMeta = Omit<PaginationMeta, 'searchQuery'>

interface DataTableProps<TData, TValue> {
  columns: ColumnDef<TData, TValue>[]
  data: TData[]
  paginationMeta: OmitPaginationMeta
  onPageChange: (page: number, perPage: number) => void
  onPageSizeChange: (pageSize: number) => void
}

export function BasicDataTable<TData, TValue>(
  props: DataTableProps<TData, TValue>,
) {
  const {
    pagination,
    pageCount,
    canPreviousPage,
    canNextPage,
    handlePreviousPage,
    handleNextPage,
    handlePageSizeChange,
  } = useDataTablePagination({
    paginationMeta: () => props.paginationMeta,
    onPageChange: props.onPageChange,
    onPageSizeChange: props.onPageSizeChange,
  })

  const table = createSolidTable({
    get data() {
      return props.data
    },
    get columns() {
      return props.columns
    },
    get rowCount() {
      return props.paginationMeta.totalCount ?? 0
    },
    get pageCount() {
      return pageCount()
    },
    manualPagination: true,
    getCoreRowModel: getCoreRowModel(),

    get state() {
      return {
        pagination: pagination(),
      }
    },
  })

  return (
    <div class="space-y-4">
      <div class="rounded-md border">
        <Table>
          <TableHeader>
            <For each={table.getHeaderGroups()}>
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
          </TableHeader>

          <TableBody>
            <Show
              when={table.getRowModel().rows.length}
              fallback={
                <TableRow>
                  <TableCell
                    colSpan={props.columns.length}
                    class="h-24 text-center"
                  >
                    No results.
                  </TableCell>
                </TableRow>
              }
            >
              <For each={table.getRowModel().rows}>
                {(row) => (
                  <TableRow
                    data-state={
                      row.getIsSelected && row.getIsSelected()
                        ? 'selected'
                        : undefined
                    }
                  >
                    <For each={row.getVisibleCells()}>
                      {(cell) => (
                        <TableCell>
                          {flexRender(
                            cell.column.columnDef.cell,
                            cell.getContext(),
                          )}
                        </TableCell>
                      )}
                    </For>
                  </TableRow>
                )}
              </For>
            </Show>
          </TableBody>
        </Table>
      </div>

      <div class="flex items-center justify-between py-2">
        <div class="text-muted-foreground flex items-center gap-2 text-sm">
          <span>表示件数</span>

          <select
            class="border-input bg-background h-8 rounded-md border px-2 text-sm"
            value={pagination().pageSize}
            onChange={(e) => {
              handlePageSizeChange(Number(e.currentTarget.value))
            }}
          >
            <option value="5">5件</option>
            <option value="10">10件</option>
            <option value="20">20件</option>
            <option value="50">50件</option>
          </select>
        </div>

        <div class="flex items-center gap-4">
          <div class="text-muted-foreground text-sm">
            {pagination().pageIndex + 1} / {pageCount()} ページ
          </div>

          <div class="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={handlePreviousPage}
              disabled={!canPreviousPage()}
            >
              Previous
            </Button>

            <Button
              variant="outline"
              size="sm"
              onClick={handleNextPage}
              disabled={!canNextPage()}
            >
              Next
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
