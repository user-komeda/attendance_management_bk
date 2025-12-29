import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import NotFound from '~/routes/[...404]'

describe('NotFound Route', () => {
  it('renders Not Found title', () => {
    render(() => (
      <MemoryRouter>
        <Route path="*all" component={NotFound} />
      </MemoryRouter>
    ))
    expect(screen.getByText('Not Found')).toBeInTheDocument()
  })

  it('renders links', () => {
    render(() => (
      <MemoryRouter>
        <Route path="*all" component={NotFound} />
      </MemoryRouter>
    ))
    expect(screen.getByText('Home')).toBeInTheDocument()
    expect(screen.getByText('About Page')).toBeInTheDocument()
  })
})

// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
/* v8 ignore stop */
