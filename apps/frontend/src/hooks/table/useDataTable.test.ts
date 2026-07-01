import { ColumnDef } from '@tanstack/solid-table'
import { createRoot } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useDataTable } from '~/hooks/table/useDataTable'

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

describe('useDataTable', () => {
  it('selectableがfalseの場合はbaseDataTableを返すこと', () => {
    createRoot((dispose) => {
      const result = useDataTable<TestData, unknown>({
        columns,
        data: [{ id: '1', name: 'Test' }],
        paginationMeta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      expect(result.table).toBeDefined()
      expect(result.pagination).toBeDefined()
      dispose()
    })
  })

  it('selectableがtrueの場合はselectableDataTableを返すこと', () => {
    createRoot((dispose) => {
      const result = useDataTable<TestData, unknown>({
        columns,
        data: [{ id: '1', name: 'Test' }],
        paginationMeta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
        selectable: true,
      })

      expect(result.table).toBeDefined()
      expect(result.pagination).toBeDefined()
      dispose()
    })
  })
})
