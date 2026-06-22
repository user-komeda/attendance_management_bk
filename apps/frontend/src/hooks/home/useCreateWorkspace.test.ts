import { useSubmission, type Submission } from '@solidjs/router'
import { renderHook } from '@solidjs/testing-library'
import { createRoot, createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useCreateWorkspace } from '~/hooks/home/useCreateWorkspace'
import {
  useHomeWorkspaces,
  type HomeWorkspacesContextValue,
} from '~/provider/homeWorkspacesProvider'

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useSubmission: vi.fn(),
  }
})

// eslint-disable-next-line max-lines-per-function
describe('useCreateWorkspace', () => {
  it('成功時にモーダルを閉じてワークスペースを再取得すること', async () => {
    const fetchWorkspaces = vi.fn()
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
    } as unknown as HomeWorkspacesContextValue)

    // Create a reactive state for submission result
    const [result, setResult] = createSignal<{ ok: boolean } | null>(null)
    vi.mocked(useSubmission).mockReturnValue({
      get result() {
        return result()
      },
      pending: false,
    } as unknown as Submission<[formData: FormData], unknown>)

    await createRoot(async () => {
      const { result: hook } = renderHook(() => useCreateWorkspace())

      hook.handleOpen()
      expect(hook.isOpen()).toBe(true)

      setResult({ ok: true })

      await new Promise((r) => setTimeout(r, 0))

      expect(hook.isOpen()).toBe(false)
      expect(fetchWorkspaces).toHaveBeenCalled()
    })
  })

  it('pending中はhandleCloseを呼んでもモーダルが閉じないこと', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: null,
      pending: true,
    } as unknown as Submission<[formData: FormData], unknown>)

    const { result: hook } = renderHook(() => useCreateWorkspace())
    hook.handleOpen()
    hook.handleClose()
    expect(hook.isOpen()).toBe(true)
  })

  it('pending中でなければhandleCloseでモーダルが閉じること', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: null,
      pending: false,
    } as unknown as Submission<[formData: FormData], unknown>)

    const { result: hook } = renderHook(() => useCreateWorkspace())
    hook.handleOpen()
    hook.handleClose()
    expect(hook.isOpen()).toBe(false)
  })
})
