import { useNavigate } from '@solidjs/router'
import { renderHook, waitFor } from '@solidjs/testing-library'
import { createRoot } from 'solid-js'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import useRequireAuth from '~/hooks/useRedirectAuth'
import { FetchResult } from '~/types/fetch'
import bffFetchWrapper from '~/util/bffFetchWrapper'

interface AuthState {
  authenticated: boolean
}

vi.mock('@solidjs/router', () => ({
  useNavigate: vi.fn(),
}))

vi.mock('~/util/bffFetchWrapper', () => ({
  default: vi.fn(),
}))

describe('useRequireAuth', () => {
  const mockNavigate = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(useNavigate).mockReturnValue(mockNavigate)
  })

  it('認証済みの場合はリダイレクトしないこと', async () => {
    vi.mocked(bffFetchWrapper).mockResolvedValue({
      ok: true,
      data: { authenticated: true },
    } as unknown as FetchResult<AuthState, string>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useRequireAuth())

      await waitFor(() => expect(result.isLoading()).toBe(false))

      expect(result.isAuthenticated()).toBe(true)
      expect(mockNavigate).not.toHaveBeenCalled()
      dispose()
    })
  })

  it('未認証の場合はログイン画面にリダイレクトすること', async () => {
    vi.mocked(bffFetchWrapper).mockResolvedValue({
      ok: true,
      data: { authenticated: false },
    } as unknown as FetchResult<AuthState, string>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useRequireAuth())

      await waitFor(() => expect(result.isLoading()).toBe(false))

      expect(result.isAuthenticated()).toBe(false)
      expect(mockNavigate).toHaveBeenCalledWith('/signin', { replace: true })
      dispose()
    })
  })

  it('APIエラーの場合は未認証として扱うこと', async () => {
    vi.mocked(bffFetchWrapper).mockResolvedValue({
      ok: false,
    } as unknown as FetchResult<AuthState, string>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useRequireAuth())

      await waitFor(() => expect(result.isLoading()).toBe(false))

      expect(result.isAuthenticated()).toBe(false)
      expect(mockNavigate).toHaveBeenCalledWith('/signin', { replace: true })
      dispose()
    })
  })

  it('dataがnullの場合も未認証として扱うこと', async () => {
    vi.mocked(bffFetchWrapper).mockResolvedValue({
      ok: true,
      data: null,
    } as unknown as FetchResult<AuthState, string>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useRequireAuth())

      await waitFor(() => expect(result.isLoading()).toBe(false))

      expect(result.isAuthenticated()).toBe(false)
      expect(mockNavigate).toHaveBeenCalledWith('/signin', { replace: true })
      dispose()
    })
  })

  it('isLoading returns true while loading', async () => {
    let resolvePromise: (value: unknown) => void
    const promise = new Promise((resolve) => {
      resolvePromise = resolve
    })
    vi.mocked(bffFetchWrapper).mockReturnValue(
      promise as unknown as Promise<FetchResult<AuthState, string>>,
    )

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useRequireAuth())

      expect(result.isLoading()).toBe(true)
      expect(result.isAuthenticated()).toBe(false)

      resolvePromise!({ ok: true, data: { authenticated: true } })
      await waitFor(() => expect(result.isLoading()).toBe(false))

      expect(result.isAuthenticated()).toBe(true)
      dispose()
    })
  })
})
