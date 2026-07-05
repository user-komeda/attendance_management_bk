import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import RequireAuth from '~/components/RequireAuth'
import useRedirectAuth from '~/hooks/useRedirectAuth'

vi.mock('~/hooks/useRedirectAuth', () => ({
  default: vi.fn(),
}))

describe('RequireAuth', () => {
  it('ロード中の場合はLoadingを表示すること', () => {
    vi.mocked(useRedirectAuth).mockReturnValue({
      isLoading: () => true,
      isAuthenticated: () => false,
    })

    render(() => (
      <RequireAuth>
        <div>Protected Content</div>
      </RequireAuth>
    ))

    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument()
  })

  it('認証済みの場合はコンテンツを表示すること', () => {
    vi.mocked(useRedirectAuth).mockReturnValue({
      isLoading: () => false,
      isAuthenticated: () => true,
    })

    render(() => (
      <RequireAuth>
        <div>Protected Content</div>
      </RequireAuth>
    ))

    expect(screen.getByText('Protected Content')).toBeInTheDocument()
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument()
  })

  it('未認証の場合はLoadingを表示すること（fallback）', () => {
    vi.mocked(useRedirectAuth).mockReturnValue({
      isLoading: () => false,
      isAuthenticated: () => false,
    })

    render(() => (
      <RequireAuth>
        <div>Protected Content</div>
      </RequireAuth>
    ))

    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument()
  })
})
