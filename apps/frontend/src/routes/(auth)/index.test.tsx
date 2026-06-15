import { MemoryRouter, Route } from '@solidjs/router'
import { render } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Home from '~/routes/(auth)'

describe('home Route', () => {
  it('renders Hello world!', () => {
    const { getByText } = render(() => (
      <MemoryRouter>
        <Route path="/" component={Home} />
      </MemoryRouter>
    ))

    expect(getByText('Hello world!')).toBeInTheDocument()
  })
})
