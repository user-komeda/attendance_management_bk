import { render, screen, fireEvent } from '@solidjs/testing-library'
import { ColumnDef } from '@tanstack/solid-table'
import { describe, it, expect, vi } from 'vitest'

import { BasicDataTable } from '~/components/table/BasicDataTable'

// eslint-disable-next-line max-lines-per-function
describe('BasicDataTable', () => {
  interface TestData {
    id: number
    name: string
  }

  const columns: ColumnDef<TestData, unknown>[] = [
    {
      header: 'ID',
      accessorKey: 'id',
    },
    {
      header: 'Name',
      accessorKey: 'name',
    },
  ]

  const data: TestData[] = [
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' },
  ]

  const paginationMeta = {
    page: 1,
    perPage: 10,
    totalPages: 1,
    totalCount: 2,
  }

  it('headersとdataを表示すること', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={data}
        paginationMeta={paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('ID')).toBeInTheDocument()
    expect(screen.getByText('Name')).toBeInTheDocument()
    expect(screen.getByText('Item 1')).toBeInTheDocument()
    expect(screen.getByText('Item 2')).toBeInTheDocument()
  })

  it('dataが空の場合はNo results.を表示すること', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={[]}
        paginationMeta={{
          ...paginationMeta,
          totalCount: 0,
          totalPages: 0,
        }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('No results.')).toBeInTheDocument()
  })

  it('選択された行にdata-state="selected"を付与すること', () => {
    const columnsWithSelection: ColumnDef<TestData, unknown>[] = [
      {
        id: 'select',
        header: 'Select',
        cell: ({ row }) => (
          <input
            type="checkbox"
            checked={row.getIsSelected()}
            onChange={row.getToggleSelectedHandler()}
          />
        ),
      },
      ...columns,
    ]

    render(() => (
      <BasicDataTable
        columns={columnsWithSelection}
        data={[data[0]]}
        paginationMeta={paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    fireEvent.click(screen.getByRole('checkbox'))

    const row = screen.getByText('Item 1').closest('tr')
    expect(row).toHaveAttribute('data-state', 'selected')
  })
})
