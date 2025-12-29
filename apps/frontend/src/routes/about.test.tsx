 

import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import About from '~/routes/about'


describe('About Route', () => {
  it('renders About Page title', () => {
    render(() => (
      <MemoryRouter>
        <Route path="/" component={About} />
      </MemoryRouter>
    ))
    expect(screen.getAllByText('About Page').length).toBeGreaterThan(0)
  })

  it('renders home link', () => {
    render(() => (
      <MemoryRouter>
        <Route path="/" component={About} />
      </MemoryRouter>
    ))
    expect(screen.getByRole('link', { name: /Home/i })).toBeInTheDocument()
  })
})

// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
/* v8 ignore stop */
