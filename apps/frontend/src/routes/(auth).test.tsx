import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import AuthLayout from '~/routes/(auth)'

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
  })

  it('pathname が / 以外の場合はサイドメニューを表示すること', async () => {
    mockPathname.value = '/apis/blogs'

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
    mockPathname.value = '/'
  })
})
