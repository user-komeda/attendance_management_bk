import { createRoot } from 'solid-js'
import { describe, it, expect } from 'vitest'

import { useCreateContentApiStep } from '~/hooks/contentApi/useCreateContentApiStep'

describe('useCreateContentApiStep', () => {
  it('初期stepはbasicであること', () => {
    createRoot((dispose) => {
      const { step } = useCreateContentApiStep()
      expect(step()).toBe('basic')
      dispose()
    })
  })

  it('初期stepResultはundefinedであること', () => {
    createRoot((dispose) => {
      const { stepResult } = useCreateContentApiStep()
      expect(stepResult()).toBeUndefined()
      dispose()
    })
  })

  it('handleBackでstepが変わること', () => {
    createRoot((dispose) => {
      const { step, handleBack } = useCreateContentApiStep()
      handleBack('type')
      expect(step()).toBe('type')
      dispose()
    })
  })

  it('handleBackでstepResultがundefinedになること', () => {
    createRoot((dispose) => {
      const { stepResult, handleBack, moveToErrorStep } =
        useCreateContentApiStep()
      moveToErrorStep({
        ok: false,
        fieldErrors: [{ key: 'name', messages: ['error'] }],
        message: '',
      })
      handleBack('basic')
      expect(stepResult()).toBeUndefined()
      dispose()
    })
  })

  it('moveToErrorStep: resultがundefinedの場合は何もしないこと', () => {
    createRoot((dispose) => {
      const { step, moveToErrorStep } = useCreateContentApiStep()
      moveToErrorStep(undefined)
      expect(step()).toBe('basic')
      dispose()
    })
  })

  it('moveToErrorStep: result.okがtrueの場合は何もしないこと', () => {
    createRoot((dispose) => {
      const { step, moveToErrorStep } = useCreateContentApiStep()
      moveToErrorStep({ ok: true, data: {} as never })
      expect(step()).toBe('basic')
      dispose()
    })
  })

  it('moveToErrorStep: nameエラーの場合はbasicステップに移動すること', () => {
    createRoot((dispose) => {
      const { step, handleBack, moveToErrorStep } = useCreateContentApiStep()
      handleBack('schema')
      moveToErrorStep({
        ok: false,
        fieldErrors: [{ key: 'name', messages: ['error'] }],
        message: '',
      })
      expect(step()).toBe('basic')
      dispose()
    })
  })

  it('moveToErrorStep: apiTypeエラーの場合はtypeステップに移動すること', () => {
    createRoot((dispose) => {
      const { step, moveToErrorStep } = useCreateContentApiStep()
      moveToErrorStep({
        ok: false,
        fieldErrors: [{ key: 'apiType', messages: ['error'] }],
        message: '',
      })
      expect(step()).toBe('type')
      dispose()
    })
  })

  it('moveToErrorStep: 不明なキーの場合はschemaステップに移動すること', () => {
    createRoot((dispose) => {
      const { step, moveToErrorStep } = useCreateContentApiStep()
      moveToErrorStep({
        ok: false,
        fieldErrors: [{ key: 'unknown' as never, messages: ['error'] }],
        message: '',
      })
      expect(step()).toBe('schema')
      dispose()
    })
  })

  it('handleNext: formがnullの場合は何もしないこと', () => {
    createRoot((dispose) => {
      const { step, handleNext } = useCreateContentApiStep()
      const button = document.createElement('button')
      const event = {
        currentTarget: button,
      } as MouseEvent & { currentTarget: HTMLButtonElement }
      handleNext('basic', 'type', event)
      expect(step()).toBe('basic')
      dispose()
    })
  })

  it('handleNext: バリデーション成功時にstepが進むこと', () => {
    createRoot((dispose) => {
      const { step, handleNext } = useCreateContentApiStep()
      const form = document.createElement('form')
      const nameInput = document.createElement('input')
      nameInput.name = 'name'
      nameInput.value = 'test-name'
      const endpointInput = document.createElement('input')
      endpointInput.name = 'endpoint'
      endpointInput.value = 'test-endpoint'
      form.appendChild(nameInput)
      form.appendChild(endpointInput)

      const button = document.createElement('button')
      form.appendChild(button)

      const event = {
        currentTarget: button,
      } as MouseEvent & { currentTarget: HTMLButtonElement }
      handleNext('basic', 'type', event)
      expect(step()).toBe('type')
      dispose()
    })
  })

  it('handleNext: バリデーション失敗時にstepResultにエラーが設定されること', () => {
    createRoot((dispose) => {
      const { step, stepResult, handleNext } = useCreateContentApiStep()
      const form = document.createElement('form')
      const button = document.createElement('button')
      form.appendChild(button)

      const event = {
        currentTarget: button,
      } as MouseEvent & { currentTarget: HTMLButtonElement }
      handleNext('basic', 'type', event)
      expect(step()).toBe('basic')
      expect(stepResult()).toBeDefined()
      expect(stepResult()?.ok).toBe(false)
      dispose()
    })
  })
})
