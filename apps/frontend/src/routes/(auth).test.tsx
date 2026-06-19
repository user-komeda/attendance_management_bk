import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import AuthLayout from '~/routes/(auth)'

vi.mock('~/components/RequireAuth', () => ({
  default: (props: { children?: import('solid-js').JSX.Element }) => (
    <div>{props.children}</div>
  ),
}))

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
})
