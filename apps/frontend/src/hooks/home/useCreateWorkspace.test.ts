import { useSubmission } from '@solidjs/router'
import { renderHook } from '@solidjs/testing-library'
import { createRoot, createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useCreateWorkspace } from '~/hooks/home/useCreateWorkspace'
import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

vi.mock('@solidjs/router', () => ({
  useSubmission: vi.fn(),
  action: vi.fn(),
}))

vi.mock('~/provider/homeWorkspacesProvider', () => ({
  useHomeWorkspaces: vi.fn(),
}))

describe('useCreateWorkspace', () => {
  it('初期状態が正しいこと', () => {
    vi.mocked(useSubmission).mockReturnValue(
      {} as unknown as ReturnType<typeof useSubmission>,
    )
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces: vi.fn(),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => useCreateWorkspace())
    expect(result.isOpen()).toBe(false)
  })

  it('handleOpenでisOpenがtrueになること', () => {
    vi.mocked(useSubmission).mockReturnValue(
      {} as unknown as ReturnType<typeof useSubmission>,
    )
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces: vi.fn(),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => useCreateWorkspace())
    result.handleOpen()
    expect(result.isOpen()).toBe(true)
  })

  it('handleCloseでisOpenがfalseになること', () => {
    vi.mocked(useSubmission).mockReturnValue({
      pending: false,
    } as unknown as ReturnType<typeof useSubmission>)
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces: vi.fn(),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => useCreateWorkspace())
    result.handleOpen()
    result.handleClose()
    expect(result.isOpen()).toBe(false)
  })

  it('pending中はhandleCloseでisOpenが変わらないこと', () => {
    vi.mocked(useSubmission).mockReturnValue({
      pending: true,
    } as unknown as ReturnType<typeof useSubmission>)
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces: vi.fn(),
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    const { result } = renderHook(() => useCreateWorkspace())
    result.handleOpen()
    result.handleClose()
    expect(result.isOpen()).toBe(true)
  })

  it('submissionが成功した場合、isOpenがfalseになりfetchWorkspacesが呼ばれること', async () => {
    const fetchWorkspaces = vi.fn()
    const [submissionResult, setSubmissionResult] = createSignal<unknown>(null)
    vi.mocked(useSubmission).mockReturnValue({
      get result() {
        return submissionResult()
      },
    } as unknown as ReturnType<typeof useSubmission>)
    vi.mocked(useHomeWorkspaces).mockReturnValue({
      fetchWorkspaces,
    } as unknown as ReturnType<typeof useHomeWorkspaces>)

    await createRoot(async (dispose) => {
      const { result } = renderHook(() => useCreateWorkspace())
      result.handleOpen()

      setSubmissionResult({ ok: true })

      await new Promise((resolve) => setTimeout(resolve, 10))

      expect(result.isOpen()).toBe(false)
      expect(fetchWorkspaces).toHaveBeenCalled()
      dispose()
    })
  })
})
