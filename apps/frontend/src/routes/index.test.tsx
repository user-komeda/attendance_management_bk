import { MemoryRouter, Route } from '@solidjs/router'
import { render } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Home from '~/routes/index'

describe('Home Route', () => {
  it('renders Hello world!', () => {
    const { getByText } = render(() => (
      <MemoryRouter>
        <Route path="/" component={Home} />
      </MemoryRouter>
    ))
    expect(getByText('Hello world!')).toBeInTheDocument()
  })

  it('renders about page link', () => {
    const { getByText } = render(() => (
      <MemoryRouter>
        <Route path="/" component={Home} />
      </MemoryRouter>
    ))
    const link = getByText('About Page')
    expect(link).toBeInTheDocument()
    expect(link).toHaveAttribute('href', '/about')
  })
})
