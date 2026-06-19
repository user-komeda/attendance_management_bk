import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { HomeTable } from '~/features/components/home/homeTable'
import { usePagination } from '~/hooks/usePagination'
import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

vi.mock('~/hooks/usePagination', () => ({
  usePagination: vi.fn(),
}))

vi.mock('~/features/components/home/homeTableHeader', () => ({
  HomeTableHeader: () => <div data-testid="header" />,
}))

vi.mock('~/components/BasicDataTable', () => ({
  BasicDataTable: (props: { data: unknown[] }) => (
    <div data-testid="table">{props.data.length} items</div>
  ),
}))

describe('HomeTable', () => {
  it('ロード中はLoadingを表示すること', () => {
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      workspaces: () => undefined,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)
    vi.mocked(usePagination).mockReturnValue({
      handlePageChange: vi.fn(),
      handlePageSizeChange: vi.fn(),
    } as unknown as ReturnType<typeof usePagination>)

    render(() => <HomeTable />)
    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(screen.getByTestId('header')).toBeInTheDocument()
  })

  it('データがある場合はテーブルを表示すること', () => {
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      workspaces: () => ({
        data: [{ name: 'WS1', slug: 'ws1', status: 'active' }],
        meta: { total: 1 },
      }),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)
    vi.mocked(usePagination).mockReturnValue({
      handlePageChange: vi.fn(),
      handlePageSizeChange: vi.fn(),
    } as unknown as ReturnType<typeof usePagination>)

    render(() => <HomeTable />)
    expect(screen.getByTestId('table')).toHaveTextContent('1 items')
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument()
  })

  it('データがnullの場合は空配列として扱うこと', () => {
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      workspaces: () => ({
        data: null,
        meta: null,
      }),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)
    vi.mocked(usePagination).mockReturnValue({
      handlePageChange: vi.fn(),
      handlePageSizeChange: vi.fn(),
    } as unknown as ReturnType<typeof usePagination>)

    render(() => <HomeTable />)
    expect(screen.getByTestId('table')).toHaveTextContent('0 items')
  })

  it('exercises branch for empty meta', () => {
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      workspaces: () => ({
        data: [],
        // meta is missing to trigger ??
      }),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)
    vi.mocked(usePagination).mockReturnValue({
      handlePageChange: vi.fn(),
      handlePageSizeChange: vi.fn(),
    } as unknown as ReturnType<typeof usePagination>)

    render(() => <HomeTable />)
    expect(screen.getByTestId('table')).toBeInTheDocument()
  })
})
