import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import { useUserId, UserIdProvider } from '~/provider/userIdProvider'

 
describe('UserIdProvider', () => {
  it('provides userId and can update it', () => {
    const TestComponent = () => {
      const { userId, setUserId } = useUserId()
      return (
        <div>
          <span data-testid="user-id">{userId()}</span>
          <button onClick={() => setUserId('new-id')}>Update</button>
        </div>
      )
    }

    render(() => (
      <UserIdProvider initialUserId="initial-id">
        <TestComponent />
      </UserIdProvider>
    ))

    expect(screen.getByTestId('user-id')).toHaveTextContent('initial-id')
    screen.getByRole('button').click()
    expect(screen.getByTestId('user-id')).toHaveTextContent('new-id')
  })

  it('can clear userId', () => {
    const TestComponent = () => {
      const { userId, clearUserId } = useUserId()
      return (
        <div>
          <span data-testid="user-id">{userId()}</span>
          <button onClick={clearUserId}>Clear</button>
        </div>
      )
    }

    render(() => (
      <UserIdProvider initialUserId="some-id">
        <TestComponent />
      </UserIdProvider>
    ))

    expect(screen.getByTestId('user-id')).toHaveTextContent('some-id')
    screen.getByRole('button').click()
    expect(screen.getByTestId('user-id')).toHaveTextContent('')
  })

  it('throws error when used outside provider', () => {
    const TestComponent = () => {
      useUserId()
      return null
    }

    expect(() => render(() => <TestComponent />)).toThrow(
      'useUserId must be used within UserIdProvider',
    )
  })
})
