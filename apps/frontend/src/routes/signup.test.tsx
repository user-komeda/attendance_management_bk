import { MemoryRouter, Route } from '@solidjs/router'
import { render } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Signup from '~/routes/signup'

describe('Signup Route', () => {
  it('renders Signup Page', () => {
    const { getByText } = render(() => (
      <MemoryRouter>
        <Route path="/" component={Signup} />
      </MemoryRouter>
    ))
    // SignupForm内の要素があるか確認（具体的にはSignupのタイトルなど）
    // SignupFormの実装を確認する必要がある
    expect(getByText(/Create an account/i)).toBeInTheDocument()
  })
})
