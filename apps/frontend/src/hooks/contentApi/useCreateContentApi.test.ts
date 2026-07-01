import { createRoot, createSignal } from 'solid-js'
import { render } from 'solid-js/web'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { useCreateContentApi } from '~/hooks/contentApi/useCreateContentApi'

const mockUseSubmission = vi.hoisted(() => vi.fn())
const mockMoveToErrorStep = vi.hoisted(() => vi.fn())
const mockUseCreateContentApiStep = vi.hoisted(() => vi.fn())

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useSubmission: mockUseSubmission,
  }
})

vi.mock('~/hooks/contentApi/useCreateContentApiStep', () => ({
  useCreateContentApiStep: mockUseCreateContentApiStep,
}))

describe('useCreateContentApi', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const mockAction = {} as never

  it('step, submission, result, handleNext, handleBackを返すこと', () => {
    createRoot((dispose) => {
      const [stepResult] = createSignal(undefined)
      mockUseSubmission.mockReturnValue({
        result: undefined,
        pending: false,
        error: undefined,
      })
      mockUseCreateContentApiStep.mockReturnValue({
        step: () => 'basic',
        stepResult,
        handleNext: vi.fn(),
        handleBack: vi.fn(),
        moveToErrorStep: mockMoveToErrorStep,
      })

      const result = useCreateContentApi({ action: mockAction })

      expect(result.step).toBeDefined()
      expect(result.submission).toBeDefined()
      expect(result.result).toBeDefined()
      expect(result.handleNext).toBeDefined()
      expect(result.handleBack).toBeDefined()
      dispose()
    })
  })

  it('stepResultがある場合はstepResultを返すこと', () => {
    createRoot((dispose) => {
      const stepResultValue = {
        ok: false as const,
        fieldErrors: [],
        message: 'error',
      }
      const [stepResult] = createSignal(stepResultValue)
      mockUseSubmission.mockReturnValue({
        result: undefined,
        pending: false,
        error: undefined,
      })
      mockUseCreateContentApiStep.mockReturnValue({
        step: () => 'basic',
        stepResult,
        handleNext: vi.fn(),
        handleBack: vi.fn(),
        moveToErrorStep: mockMoveToErrorStep,
      })

      const { result } = useCreateContentApi({ action: mockAction })

      expect(result()).toEqual(stepResultValue)
      dispose()
    })
  })

  it('stepResultがない場合はsubmission.resultを返すこと', () => {
    createRoot((dispose) => {
      const submissionResult = { ok: true as const, data: {} as never }
      const [stepResult] = createSignal(undefined)
      mockUseSubmission.mockReturnValue({
        result: submissionResult,
        pending: false,
        error: undefined,
      })
      mockUseCreateContentApiStep.mockReturnValue({
        step: () => 'basic',
        stepResult,
        handleNext: vi.fn(),
        handleBack: vi.fn(),
        moveToErrorStep: mockMoveToErrorStep,
      })

      const { result } = useCreateContentApi({ action: mockAction })

      expect(result()).toEqual(submissionResult)
      dispose()
    })
  })

  it('createEffectでmoveToErrorStepが呼ばれること', async () => {
    const submissionResult = {
      ok: false as const,
      fieldErrors: [],
      message: 'error',
    }
    const [stepResult] = createSignal(undefined)
    mockUseSubmission.mockReturnValue({
      result: submissionResult,
      pending: false,
      error: undefined,
    })
    mockUseCreateContentApiStep.mockReturnValue({
      step: () => 'basic',
      stepResult,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
      moveToErrorStep: mockMoveToErrorStep,
    })

    const container = document.createElement('div')
    const dispose = render(() => {
      useCreateContentApi({ action: mockAction })
      return null
    }, container)

    await new Promise((resolve) => setTimeout(resolve, 0))
    expect(mockMoveToErrorStep).toHaveBeenCalledWith(submissionResult)
    dispose()
  })
})
