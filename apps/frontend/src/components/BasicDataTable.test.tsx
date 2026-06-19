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

  it('paginationMetaに基づいてページ情報を表示すること', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={data}
        paginationMeta={{
          page: 2,
          perPage: 10,
          totalPages: 5,
          totalCount: 50,
        }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('2 / 5 ページ')).toBeInTheDocument()
  })

  it('表示件数を変更したときonPageSizeChangeを呼ぶこと', () => {
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

    fireEvent.change(screen.getByRole('combobox'), {
      target: { value: '20' },
    })

    expect(onPageSizeChange).toHaveBeenCalledWith(20)
  })

  it('Nextをクリックしたとき次ページをonPageChangeに渡すこと', () => {
    const onPageChange = vi.fn()

    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[0]]}
        paginationMeta={{
          page: 1,
          perPage: 1,
          totalPages: 2,
          totalCount: 2,
        }}
        onPageChange={onPageChange}
        onPageSizeChange={vi.fn()}
      />
    ))

    fireEvent.click(screen.getByRole('button', { name: /next/i }))

    expect(onPageChange).toHaveBeenCalledWith(2, 1)
  })

  it('Previousをクリックしたとき前ページをonPageChangeに渡すこと', () => {
    const onPageChange = vi.fn()

    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[1]]}
        paginationMeta={{
          page: 2,
          perPage: 1,
          totalPages: 2,
          totalCount: 2,
        }}
        onPageChange={onPageChange}
        onPageSizeChange={vi.fn()}
      />
    ))

    fireEvent.click(screen.getByRole('button', { name: /previous/i }))

    expect(onPageChange).toHaveBeenCalledWith(1, 1)
  })

  it('最初のページではPreviousをdisabledにすること', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[0]]}
        paginationMeta={{
          page: 1,
          perPage: 1,
          totalPages: 2,
          totalCount: 2,
        }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByRole('button', { name: /previous/i })).toBeDisabled()
    expect(screen.getByRole('button', { name: /next/i })).not.toBeDisabled()
  })

  it('最後のページではNextをdisabledにすること', () => {
    render(() => (
      <BasicDataTable
        columns={columns}
        data={[data[1]]}
        paginationMeta={{
          page: 2,
          perPage: 1,
          totalPages: 2,
          totalCount: 2,
        }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByRole('button', { name: /previous/i })).not.toBeDisabled()
    expect(screen.getByRole('button', { name: /next/i })).toBeDisabled()
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

  it('paginationMetaが不足している場合はデフォルト値でページ情報を表示すること', () => {
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
