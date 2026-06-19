import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import Home from '~/routes/(auth)/index'

// mock useSubmission and bffFetchWrapper
vi.mock('~/util/bffFetchWrapper', () => ({
  default: vi.fn().mockResolvedValue({
    ok: true,
    data: {
      data: [
        {
          name: 'Test Workspace',
          slug: 'test-workspace',
          status: 'active',
        },
      ],
      meta: { page: 1, totalPages: 1, totalCount: 1, perPage: 10 },
    },
  }),
}))

describe('home Route', () => {
  it('renders HomePage', async () => {
    render(() => (
      <MemoryRouter>
        <Route path="/" component={Home} />
      </MemoryRouter>
    ))

    expect(await screen.findByText('Test Workspace')).toBeInTheDocument()
  })
})
