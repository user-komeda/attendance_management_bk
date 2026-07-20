import { createRoot } from 'solid-js'
import { afterEach, describe, expect, it, vi } from 'vitest'

import { useFieldArray } from '~/hooks/useFieldArray'

describe('useFieldArray', () => {
  afterEach(() => {
    vi.unstubAllGlobals()
  })

  it('初期状態で1件のフィールドを持つこと', () => {
    vi.stubGlobal('crypto', {
      randomUUID: vi.fn().mockReturnValue('field-1'),
    })

    createRoot((dispose) => {
      const { fields } = useFieldArray()

      expect(fields()).toEqual([{ key: 'field-1' }])

      dispose()
    })
  })

  it('appendでフィールドを追加できること', () => {
    vi.stubGlobal('crypto', {
      randomUUID: vi
        .fn()
        .mockReturnValueOnce('field-1')
        .mockReturnValueOnce('field-2'),
    })

    createRoot((dispose) => {
      const { fields, append } = useFieldArray()

      append()

      expect(fields()).toEqual([{ key: 'field-1' }, { key: 'field-2' }])

      dispose()
    })
  })

  it('removeは1件しかない場合は削除しないこと', () => {
    vi.stubGlobal('crypto', {
      randomUUID: vi.fn().mockReturnValue('field-1'),
    })

    createRoot((dispose) => {
      const { fields, remove } = useFieldArray()

      remove('field-1')

      expect(fields()).toEqual([{ key: 'field-1' }])

      dispose()
    })
  })

  it('removeは2件以上の場合に対象キーを削除すること', () => {
    vi.stubGlobal('crypto', {
      randomUUID: vi
        .fn()
        .mockReturnValueOnce('field-1')
        .mockReturnValueOnce('field-2')
        .mockReturnValueOnce('field-3'),
    })

    createRoot((dispose) => {
      const { fields, append, remove } = useFieldArray()

      append()
      append()
      remove('field-2')

      expect(fields()).toEqual([{ key: 'field-1' }, { key: 'field-3' }])

      dispose()
    })
  })
})
