import { ColumnDef } from '@tanstack/solid-table'
import { createRoot } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useDataTablePagination } from '~/hooks/table/useDataTablePagination'
import { useSelectableDataTable } from '~/hooks/table/useSelectableDataTable'

interface TestData {
  id: string
  name: string
}

const columns: ColumnDef<TestData, unknown>[] = [
  { accessorKey: 'id', header: 'ID' },
  { accessorKey: 'name', header: 'Name' },
]

const paginationMeta = {
  page: 1,
  perPage: 10,
  totalPages: 2,
  totalCount: 15,
}

describe('useSelectableDataTable', () => {
  it('tableとrowSelectionを返すこと', () => {
    createRoot((dispose) => {
      const paginationData = useDataTablePagination({
        paginationMeta: () => paginationMeta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      const { table, rowSelection } = useSelectableDataTable(
        {
          columns,
          data: [{ id: '1', name: 'Test' }],
          paginationMeta,
          onPageChange: vi.fn(),
          onPageSizeChange: vi.fn(),
        },
        paginationData,
      )

      expect(table).toBeDefined()
      expect(rowSelection()).toEqual({})
      dispose()
    })
  })

  it('行選択が更新できること', () => {
    createRoot((dispose) => {
      const paginationData = useDataTablePagination({
        paginationMeta: () => paginationMeta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      const { table, rowSelection } = useSelectableDataTable(
        {
          columns,
          data: [{ id: '1', name: 'Test' }],
          paginationMeta,
          onPageChange: vi.fn(),
          onPageSizeChange: vi.fn(),
        },
        paginationData,
      )

      table.setRowSelection({ '0': true })
      expect(rowSelection()).toEqual({ '0': true })
      dispose()
    })
  })

  it('updaterが関数の場合も行選択が更新できること', () => {
    createRoot((dispose) => {
      const paginationData = useDataTablePagination({
        paginationMeta: () => paginationMeta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      const { table, rowSelection } = useSelectableDataTable(
        {
          columns,
          data: [{ id: '1', name: 'Test' }],
          paginationMeta,
          onPageChange: vi.fn(),
          onPageSizeChange: vi.fn(),
        },
        paginationData,
      )

      table.setRowSelection((prev) => ({ ...prev, '0': true }))
      expect(rowSelection()).toEqual({ '0': true })
      dispose()
    })
  })

  it('totalCountがundefinedの場合はrowCountが0になること', () => {
    createRoot((dispose) => {
      const metaWithoutCount = {
        ...paginationMeta,
        totalCount: undefined as unknown as number,
      }
      const paginationData = useDataTablePagination({
        paginationMeta: () => metaWithoutCount,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      const { table } = useSelectableDataTable(
        {
          columns,
          data: [],
          paginationMeta: metaWithoutCount,
          onPageChange: vi.fn(),
          onPageSizeChange: vi.fn(),
        },
        paginationData,
      )

      expect(table.getRowCount()).toBe(0)
      dispose()
    })
  })
})
