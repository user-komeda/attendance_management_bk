import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import Page from '~/routes/(auth)/(home)/index'

vi.mock('~/features/pages/home/HomePage', () => ({
  HomePage: () => <div>HomePage</div>,
}))

describe('(auth)/(home)/index', () => {
  it('renders HomePage', () => {
    render(() => <Page />)
    expect(screen.getByText('HomePage')).toBeInTheDocument()
  })
})
