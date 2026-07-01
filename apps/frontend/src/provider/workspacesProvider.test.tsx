import { render, screen, waitFor } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import {
  useWorkspace,
  WorkspaceProvider,
  fetchWorkspacesRequest,
} from '~/provider/workspacesProvider'

vi.mock('~/util/bffFetchWrapper', () => ({
  default: vi.fn().mockResolvedValue({
    ok: true,
    data: {
      data: [{ name: 'WS1', slug: 'ws1', status: 'active' }],
      meta: { page: 1, totalPages: 1, totalCount: 1, perPage: 10 },
    },
  }),
}))

 
describe('homeWorkspacesProvider', () => {
  it('useHomeWorkspaces throws error when used outside provider', () => {
    expect(() => useWorkspace()).toThrow(
      'useWorkspace must be used within WorkspaceProvider',
    )
  })

  it('WorkspaceProvider provides contentApi to children', async () => {
    const TestComponent = () => {
      const { workspaces } = useWorkspace()
      return <div>{workspaces()?.data[0]?.name ?? 'loading'}</div>
    }

    render(() => (
      <WorkspaceProvider>
        <TestComponent />
      </WorkspaceProvider>
    ))

    await waitFor(() => expect(screen.getByText('WS1')).toBeInTheDocument())
  })

  it('WorkspaceProvider provides isLoadingWorkspaces', async () => {
    const TestComponent = () => {
      const { isLoadingWorkspaces } = useWorkspace()
      return <div>{isLoadingWorkspaces() ? 'loading' : 'done'}</div>
    }

    render(() => (
      <WorkspaceProvider>
        <TestComponent />
      </WorkspaceProvider>
    ))

    await waitFor(() => expect(screen.getByText('done')).toBeInTheDocument())
  })

  it('WorkspaceProvider refetchWorkspaces works', async () => {
    const TestComponent = () => {
      const { workspaces, refetchWorkspaces } = useWorkspace()
      return (
        <div>
          <div>{workspaces()?.data[0]?.name ?? 'loading'}</div>
          <button onClick={() => refetchWorkspaces()}>Refetch</button>
        </div>
      )
    }

    render(() => (
      <WorkspaceProvider>
        <TestComponent />
      </WorkspaceProvider>
    ))

    await waitFor(() => expect(screen.getByText('WS1')).toBeInTheDocument())
    screen.getByRole('button').click()
    await waitFor(() => expect(screen.getByText('WS1')).toBeInTheDocument())
  })
})

describe('fetchWorkspacesRequest', () => {
  it('searchQueryとpageを指定してリクエストすること', async () => {
    const result = await fetchWorkspacesRequest({
      searchQuery: 'test',
      page: 2,
      perPage: 5,
    })
    expect(result.data[0].name).toBe('WS1')
  })

  it('パラメータなしでリクエストすること', async () => {
    const result = await fetchWorkspacesRequest()
    expect(result.data[0].name).toBe('WS1')
  })

  it('result.okがfalseの場合エラーをスローすること', async () => {
    const bffFetchWrapper = (await import('~/util/bffFetchWrapper')).default
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({ ok: false } as never)
    await expect(fetchWorkspacesRequest()).rejects.toThrow(
      'Failed to load workspaces',
    )
  })

  it('result.dataがnullの場合デフォルト値を返すこと', async () => {
    const bffFetchWrapper = (await import('~/util/bffFetchWrapper')).default
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({
      ok: true,
      data: null,
    } as never)
    const result = await fetchWorkspacesRequest()
    expect(result.data).toEqual([])
  })
})
