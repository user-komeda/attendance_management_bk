import { render } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import { HomePage } from '~/features/pages/home/HomePage'

describe('home Route', () => {
  it('renders HomePage', () => {
    const { container } = render(() => <HomePage />)

    expect(container.textContent).toContain('Hello world!')
  })
})
