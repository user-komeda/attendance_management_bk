import { MemoryRouter, Route } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Nav from '~/components/Nav'

describe('Nav', () => {
  it('renders navigation links', () => {
    render(() => (
      <MemoryRouter>
        <Route path="/" component={Nav} />
      </MemoryRouter>
    ))

    expect(screen.getByText('Home')).toBeInTheDocument()
    expect(screen.getByText('About')).toBeInTheDocument()
  })

  it('highlights active link', () => {
    render(() => (
      <MemoryRouter>
        <Route path="/" component={Nav} />
      </MemoryRouter>
    ))

    const homeLink = screen.getByText('Home').parentElement
    expect(homeLink).toHaveClass('border-sky-600')

    const aboutLink = screen.getByText('About').parentElement
    expect(aboutLink).toHaveClass('border-transparent')
  })
})

// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
/* v8 ignore stop */
