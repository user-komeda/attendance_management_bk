import { render, screen, fireEvent } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import Counter from '~/components/Counter'


describe('Counter', () => {
  it('should increment count when clicked', async () => {
    render(() => <Counter />)
    const button = screen.getByRole('button')
    expect(button).toHaveTextContent('Clicks: 0')
    
    fireEvent.click(button)
    expect(button).toHaveTextContent('Clicks: 1')
  })
})
