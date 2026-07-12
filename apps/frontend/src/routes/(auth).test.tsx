import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import AuthLayout from '~/routes/(auth)'

const mockWorkspaceDetail = { value: undefined as unknown }
const mockWorkspaceList = { value: [] as unknown[] }

vi.mock('~/provider/workspacesProvider', () => ({
  WorkspaceProvider: (props: { children: import('solid-js').JSX.Element }) => (
    <>{props.children}</>
  ),
  useWorkspace: () => ({
    workspaces: () => ({ data: mockWorkspaceList.value }),
  }),
}))

vi.mock('~/provider/workspacesDetailProvider', () => ({
  WorkspaceDetailProvider: (props: {
    children: import('solid-js').JSX.Element
    slug?: string
  }) => <>{props.children}</>,
  useWorkspaceDetail: () => ({
    workspaceDetail: () => mockWorkspaceDetail.value,
  }),
}))

vi.mock('~/components/sideMenu/SideMenuWrap', () => ({
  SideMenuWrap: (props: { isTooltip: boolean }) => (
    <div data-testid={props.isTooltip ? 'icon-menu' : 'detail-menu'} />
  ),
}))

vi.mock('~/util/sideMenuItems', () => ({
  buildSideIconItems: () => [{ key: 'icon' }],
  buildSideMenuItems: () => [{ key: 'menu' }],
}))

vi.mock('~/util/bffFetchWrapper', () => ({
  default: vi.fn().mockResolvedValue({
    ok: true,
    data: {
      data: [],
      meta: { page: 1, totalPages: 0, totalCount: 0, perPage: 10 },
    },
  }),
}))

vi.mock('~/components/RequireAuth', () => ({
  default: (props: { children?: import('solid-js').JSX.Element }) => (
    <div>{props.children}</div>
  ),
}))

const mockPathname = { value: '/' }
vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useLocation: () => ({
      get pathname() {
        return mockPathname.value
      },
    }),
  }
})

describe('AuthLayout', () => {
  it('renders children with UserIdProvider and RequireAuth', async () => {
    mockPathname.value = '/'
    mockWorkspaceDetail.value = undefined

    render(() => (
      <MemoryRouter>
        <Route
          path="/"
          component={(props) => (
            <AuthLayout {...props}>
              <div data-testid="child">Authenticated Content</div>
            </AuthLayout>
          )}
        />
      </MemoryRouter>
    ))

    expect(await screen.findByText('Authenticated Content')).toBeInTheDocument()
    expect(screen.getByTestId('icon-menu')).toBeInTheDocument()
    expect(screen.queryByTestId('detail-menu')).not.toBeInTheDocument()
  })

  it('pathname が / 以外の場合はサイドメニューを表示すること', async () => {
    mockPathname.value = '/apis/blogs'
    mockWorkspaceDetail.value = { id: 'workspace-id' }

    render(() => (
      <MemoryRouter>
        <Route
          path="/"
          component={(props) => (
            <AuthLayout {...props}>
              <div data-testid="child">Blog Content</div>
            </AuthLayout>
          )}
        />
      </MemoryRouter>
    ))

    expect(await screen.findByText('Blog Content')).toBeInTheDocument()
    expect(screen.getByTestId('icon-menu')).toBeInTheDocument()
    expect(screen.getByTestId('detail-menu')).toBeInTheDocument()
    mockPathname.value = '/'
    mockWorkspaceDetail.value = undefined
  })
})
