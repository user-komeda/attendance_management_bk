import { render, screen, fireEvent } from '@solidjs/testing-library'
import { ColumnDef } from '@tanstack/solid-table'
import { describe, it, expect, vi } from 'vitest'

import { BasicDataTable } from '~/components/table/BasicDataTable'
import { useDataTable } from '~/hooks/table/useDataTable'
import { PaginationMeta } from '~/schema/api/paginationMetas'

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useNavigate: () => vi.fn(),
  }
})

describe('PaginationArea', () => {
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

  interface WrapperProps {
    data: TestData[]
    paginationMeta: Omit<PaginationMeta, 'searchQuery'>
    onPageChange: (page: number, perPage: number) => void
    onPageSizeChange: (pageSize: number) => void
  }

  const TableWrapper = (props: WrapperProps) => {
    const { table, ...paginationData } = useDataTable({
      get columns() {
        return columns
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
      <BasicDataTable
        table={table}
        columns={columns}
        paginationData={paginationData}
      />
    )
  }

  it('paginationMetaに基づいてページ情報を表示すること', () => {
    render(() => (
      <TableWrapper
        data={data}
        paginationMeta={{ page: 2, perPage: 10, totalPages: 5, totalCount: 50 }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('2 / 5 ページ')).toBeInTheDocument()
  })

  it('表示件数を変更したときonPageSizeChangeを呼ぶこと', () => {
    const onPageSizeChange = vi.fn()

    render(() => (
      <TableWrapper
        data={data}
        paginationMeta={{ page: 1, perPage: 10, totalPages: 1, totalCount: 2 }}
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
      <TableWrapper
        data={[data[0]]}
        paginationMeta={{ page: 1, perPage: 1, totalPages: 2, totalCount: 2 }}
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
      <TableWrapper
        data={[data[1]]}
        paginationMeta={{ page: 2, perPage: 1, totalPages: 2, totalCount: 2 }}
        onPageChange={onPageChange}
        onPageSizeChange={vi.fn()}
      />
    ))

    fireEvent.click(screen.getByRole('button', { name: /previous/i }))

    expect(onPageChange).toHaveBeenCalledWith(1, 1)
  })

  it('最初のページではPreviousをdisabledにすること', () => {
    render(() => (
      <TableWrapper
        data={[data[0]]}
        paginationMeta={{ page: 1, perPage: 1, totalPages: 2, totalCount: 2 }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByRole('button', { name: /previous/i })).toBeDisabled()
    expect(screen.getByRole('button', { name: /next/i })).not.toBeDisabled()
  })

  it('最後のページではNextをdisabledにすること', () => {
    render(() => (
      <TableWrapper
        data={[data[1]]}
        paginationMeta={{ page: 2, perPage: 1, totalPages: 2, totalCount: 2 }}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByRole('button', { name: /previous/i })).not.toBeDisabled()
    expect(screen.getByRole('button', { name: /next/i })).toBeDisabled()
  })

  it('paginationMetaが不足している場合はデフォルト値でページ情報を表示すること', () => {
    render(() => (
      <TableWrapper
        data={data}
        paginationMeta={{} as unknown as Omit<PaginationMeta, 'searchQuery'>}
        onPageChange={vi.fn()}
        onPageSizeChange={vi.fn()}
      />
    ))

    expect(screen.getByText('1 / 0 ページ')).toBeInTheDocument()
  })
})
