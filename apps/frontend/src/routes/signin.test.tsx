import { MemoryRouter, Route } from '@solidjs/router'
import { render } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Signin from '~/routes/signin'

describe('Signin Route', () => {
  it('renders Signin Page', () => {
    const { getByRole } = render(() => (
      <MemoryRouter>
        <Route path="/" component={Signin} />
      </MemoryRouter>
    ))
    expect(getByRole('button', { name: /login/i })).toBeInTheDocument()
  })
})
