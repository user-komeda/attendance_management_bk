import { fireEvent, render, screen } from '@solidjs/testing-library'
import { ColumnDef, RowSelectionState } from '@tanstack/solid-table'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { BasicDataTable } from '~/components/table/BasicDataTable'
import { useDataTable } from '~/hooks/table/useDataTable'
import { PaginationMeta } from '~/schema/api/paginationMetas'

const navigateMock = vi.hoisted(() => vi.fn())

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>

  return {
    ...actual,
    useNavigate: () => navigateMock,
  }
})

 
describe('BasicDataTable', () => {
  interface TestData {
    id: string
    name: string
  }

  const columns: ColumnDef<TestData, unknown>[] = [
    {
      accessorKey: 'id',
      header: 'ID',
    },
    {
      accessorKey: 'name',
      header: 'Name',
    },
  ]

  const paginationMeta: Omit<PaginationMeta, 'searchQuery'> = {
    page: 1,
    perPage: 10,
    totalPages: 1,
    totalCount: 1,
  }

  interface TableWrapperProps {
    data: TestData[]
    getRowHref?: (row: TestData) => string
    selectable?: boolean
    initialRowSelection?: RowSelectionState
  }

  const TableWrapper = (props: TableWrapperProps) => {
    const { table, ...paginationData } = useDataTable<TestData, unknown>({
      get columns() {
        return columns
      },
      get data() {
        return props.data
      },
      get paginationMeta() {
        return paginationMeta
      },
      onPageChange: vi.fn(),
      onPageSizeChange: vi.fn(),
      selectable: props.selectable,
    })

    if (props.initialRowSelection) {
      table.setRowSelection(props.initialRowSelection)
    }

    return (
      <BasicDataTable
        table={table}
        columns={columns}
        paginationData={paginationData}
        getRowHref={props.getRowHref}
      />
    )
  }

  beforeEach(() => {
    navigateMock.mockClear()
  })

  it('ヘッダーと行データを表示すること', () => {
    render(() => (
      <TableWrapper data={[{ id: 'workspace-1', name: 'Workspace 1' }]} />
    ))

    expect(screen.getByText('ID')).toBeInTheDocument()
    expect(screen.getByText('Name')).toBeInTheDocument()
    expect(screen.getByText('workspace-1')).toBeInTheDocument()
    expect(screen.getByText('Workspace 1')).toBeInTheDocument()
  })

  it('データが空の場合はNo results.を表示すること', () => {
    render(() => <TableWrapper data={[]} />)

    expect(screen.getByText('No results.')).toBeInTheDocument()
  })

  it('getRowHrefがある場合は行クリックで遷移すること', () => {
    render(() => (
      <TableWrapper
        data={[{ id: 'workspace-1', name: 'Workspace 1' }]}
        getRowHref={(row) => `/workspaces/${row.id}`}
      />
    ))

    fireEvent.click(screen.getByText('workspace-1').closest('tr')!)

    expect(navigateMock).toHaveBeenCalledWith('/workspaces/workspace-1')
  })

  it('getRowHrefがない場合は行クリックしても遷移しないこと', () => {
    render(() => (
      <TableWrapper data={[{ id: 'workspace-1', name: 'Workspace 1' }]} />
    ))

    fireEvent.click(screen.getByText('workspace-1').closest('tr')!)

    expect(navigateMock).not.toHaveBeenCalled()
  })

  it('getRowHrefがundefinedを返す場合は行クリックしても遷移しないこと', () => {
    render(() => (
      <TableWrapper
        data={[{ id: 'workspace-1', name: 'Workspace 1' }]}
        getRowHref={() => undefined as unknown as string}
      />
    ))

    fireEvent.click(screen.getByText('workspace-1').closest('tr')!)

    expect(navigateMock).not.toHaveBeenCalled()
  })

  it('行が選択状態の場合はdata-stateがselectedになること', () => {
    render(() => (
      <TableWrapper
        data={[{ id: 'workspace-1', name: 'Workspace 1' }]}
        selectable={true}
        initialRowSelection={{ '0': true }}
      />
    ))

    const row = screen.getByText('workspace-1').closest('tr')!
    expect(row.getAttribute('data-state')).toBe('selected')
  })
})
