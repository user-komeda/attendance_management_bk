import { render, screen, fireEvent } from '@solidjs/testing-library'
import { ColumnDef } from '@tanstack/solid-table'
import { describe, it, expect, vi } from 'vitest'

import { BasicDataTable } from '~/components/BasicDataTable'

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

  it('renders data and headers', () => {
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

  it('renders "No results." when data is empty', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={[]}
        paginationMeta={{ ...paginationMeta, totalCount: 0, totalPages: 0 }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('No results.')).toBeInTheDocument()
  })

  it('calls onPageSizeChange when select value changes', () => {
    const onPageSizeChange = vi.fn()
    render(() => (
      <BasicDataTable
        columns={columns}
        data={data}
        paginationMeta={paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={onPageSizeChange}
      />
    ))

    const select = screen.getByRole('combobox')
    fireEvent.change(select, { target: { value: '20' } })

    expect(onPageSizeChange).toHaveBeenCalledWith(20)
  })

  it('handles pagination button clicks', () => {
    const onPageChange = vi.fn()
    const multiPageMeta = {
      page: 1,
      perPage: 1,
      totalPages: 2,
      totalCount: 2,
    }

    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[0]]}
        paginationMeta={multiPageMeta}
        onPageChange={onPageChange}
        onPageSizeChange={vi.fn()}
      />
    ))

    const nextButton = screen.getByRole('button', { name: /next/i })
    fireEvent.click(nextButton)
    expect(onPageChange).toHaveBeenCalledWith(2, 1)

    const prevButton = screen.getByRole('button', { name: /previous/i })
    // In this test, current page is 1 and totalPages is 2. prev should be disabled.
    // If we click it, onPageChange should NOT be called.
    fireEvent.click(prevButton)
    expect(onPageChange).not.toHaveBeenCalledWith(0, 1)
  })

  it('handles previous button click and enables it on page 2', () => {
    const onPageChange = vi.fn()
    const pageTwoMeta = {
      page: 2,
      perPage: 1,
      totalPages: 2,
      totalCount: 2,
    }

    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[1]]}
        paginationMeta={pageTwoMeta}
        onPageChange={onPageChange}
        onPageSizeChange={vi.fn()}
      />
    ))

    const prevButton = screen.getByRole('button', { name: /previous/i })
    fireEvent.click(prevButton)
    expect(onPageChange).toHaveBeenCalledWith(1, 1)

    const nextButton = screen.getByRole('button', { name: /next/i })
    // In this test, current page is 2 and totalPages is 2. next should be disabled.
    fireEvent.click(nextButton)
    expect(onPageChange).not.toHaveBeenCalledWith(3, 1)
  })

  it('handles placeholder headers', () => {
    const columnsWithPlaceholder: ColumnDef<TestData, unknown>[] = [
      {
        header: 'ID',
        accessorKey: 'id',
      },
      {
        header: () => null, // This might trigger isPlaceholder in some contexts, but usually isPlaceholder is for grouped headers
        accessorKey: 'name',
      },
    ]

    render(() => (
      <BasicDataTable
        columns={columnsWithPlaceholder}
        data={data}
        paginationMeta={paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('ID')).toBeInTheDocument()
  })

  it('renders selected row state', () => {
    const dataWithSelection = [{ id: 1, name: 'Item 1' }]

    const Selectioncolumns: ColumnDef<TestData, unknown>[] = [
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
        columns={Selectioncolumns}
        data={dataWithSelection}
        paginationMeta={paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    const checkbox = screen.getByRole('checkbox')
    fireEvent.click(checkbox)

    // Check if data-state="selected" appears
    const row = screen.getByText('Item 1').closest('tr')
    expect(row).toHaveAttribute('data-state', 'selected')
  })

  it('uses default values for paginationMeta when missing', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={data}
        paginationMeta={{} as unknown as typeof paginationMeta}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))
    expect(screen.getByText('1 / 0 ページ')).toBeInTheDocument()
  })
})
