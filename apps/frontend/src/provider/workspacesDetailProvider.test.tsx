import { render, screen, waitFor } from '@solidjs/testing-library'
import { useContext } from 'solid-js'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import {
  WorkspaceDetailProvider,
  WorkspaceDetailContext,
  fetchWorkspaceDetailRequest,
  useWorkspaceDetail,
} from '~/provider/workspacesDetailProvider'

const mockBffFetchWrapper = vi.hoisted(() => vi.fn())

vi.mock('~/util/bffFetchWrapper', () => ({
  default: mockBffFetchWrapper,
}))

const mockWorkspaceDetail = {
  id: 'ws-1',
  workSpaces: {
    id: 'ws-1',
    name: 'Workspace 1',
    slug: 'ws-1',
  },
  role: 'owner',
  memberShips: [],
}

describe('fetchWorkspaceDetailRequest', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('成功した場合はworkspaceDetailを返すこと', async () => {
    mockBffFetchWrapper.mockResolvedValue({
      ok: true,
      data: mockWorkspaceDetail,
    })

    const result = await fetchWorkspaceDetailRequest('ws-1')
    expect(result).toEqual(mockWorkspaceDetail)
  })

  it('result.okがfalseの場合はエラーをthrowすること', async () => {
    mockBffFetchWrapper.mockResolvedValue({ ok: false })

    await expect(fetchWorkspaceDetailRequest('ws-1')).rejects.toThrow(
      'Failed to load workspace detail',
    )
  })

  it('result.dataがundefinedの場合はエラーをthrowすること', async () => {
    mockBffFetchWrapper.mockResolvedValue({ ok: true, data: undefined })

    await expect(fetchWorkspaceDetailRequest('ws-1')).rejects.toThrow(
      'Failed to load workspace detail',
    )
  })
})

describe('WorkspaceDetailProvider', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const ChildComponent = () => {
    const ctx = useContext(WorkspaceDetailContext)
    return (
      <div>
        <div data-testid="detail">
          {ctx?.workspaceDetail()?.workSpaces.name ?? 'loading'}
        </div>
        <div data-testid="loading">
          {String(ctx?.isLoadingWorkspaceDetail())}
        </div>
      </div>
    )
  }

  it('workspaceDetailをchildrenに提供すること', async () => {
    mockBffFetchWrapper.mockResolvedValue({
      ok: true,
      data: mockWorkspaceDetail,
    })

    render(() => (
      <WorkspaceDetailProvider slug="ws-1">
        <ChildComponent />
      </WorkspaceDetailProvider>
    ))

    await waitFor(() => {
      expect(screen.getByTestId('detail').textContent).toBe('Workspace 1')
    })
  })

  it('isLoadingWorkspaceDetailを提供すること', async () => {
    mockBffFetchWrapper.mockResolvedValue({
      ok: true,
      data: mockWorkspaceDetail,
    })

    render(() => (
      <WorkspaceDetailProvider slug="ws-1">
        <ChildComponent />
      </WorkspaceDetailProvider>
    ))

    await waitFor(() => {
      expect(screen.getByTestId('loading').textContent).toBe('false')
    })
  })

  it('refetchWorkspaceDetailが動作すること', async () => {
    mockBffFetchWrapper.mockResolvedValue({
      ok: true,
      data: mockWorkspaceDetail,
    })

    const RefetchChild = () => {
      const ctx = useContext(WorkspaceDetailContext)
      ctx?.refetchWorkspaceDetail()
      return <div data-testid="refetch">done</div>
    }

    render(() => (
      <WorkspaceDetailProvider slug="ws-1">
        <RefetchChild />
      </WorkspaceDetailProvider>
    ))

    await waitFor(() => {
      expect(screen.getByTestId('refetch')).toBeInTheDocument()
    })
  })
})

describe('useWorkspaceDetail', () => {
  it('Provider外で使用した場合はエラーをthrowすること', () => {
    expect(() => {
      render(() => {
        const TestComponent = () => {
          useWorkspaceDetail()
          return <div />
        }
        return <TestComponent />
      })
    }).toThrow()
  })

  it('Provider内で使用した場合はcontextを返すこと', async () => {
    mockBffFetchWrapper.mockResolvedValue({
      ok: true,
      data: mockWorkspaceDetail,
    })

    const TestComponent = () => {
      const ctx = useWorkspaceDetail()
      return (
        <div data-testid="ctx">
          {ctx.workspaceDetail()?.workSpaces.name ?? 'loading'}
        </div>
      )
    }

    render(() => (
      <WorkspaceDetailProvider slug="ws-1">
        <TestComponent />
      </WorkspaceDetailProvider>
    ))

    await waitFor(() => {
      expect(screen.getByTestId('ctx').textContent).toBe('Workspace 1')
    })
  })
})
