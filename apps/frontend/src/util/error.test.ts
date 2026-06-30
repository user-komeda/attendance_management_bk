import { describe, it, expect } from 'vitest'

import { ActionResult } from '~/types/action'
import { findError, findActionMessage, createError } from '~/util/error'

 
describe('error utils', () => {
  describe('findError', () => {
    it('resultがundefinedの場合はundefinedを返すこと', () => {
      expect(findError(undefined, 'key')).toBeUndefined()
    })

    it('result.okがtrueの場合はundefinedを返すこと', () => {
      expect(findError({ ok: true }, 'key')).toBeUndefined()
    })

    it('該当するkeyのエラーがある場合はそのメッセージを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [{ key: 'email', message: 'invalid email' }],
        message: 'error',
      }
      expect(findError(result, 'email')).toBe('invalid email')
    })

    it('該当するkeyのエラーがない場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [{ key: 'password', message: 'too short' }],
        message: 'error',
      }
      expect(findError(result, 'email')).toBeUndefined()
    })

    it('fieldErrorsがundefinedの場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
        message: 'error',
      }
      expect(
        findError(result as unknown as ActionResult, 'email'),
      ).toBeUndefined()
    })
  })

  describe('findActionMessage', () => {
    it('resultがundefinedの場合はundefinedを返すこと', () => {
      expect(findActionMessage(undefined)).toBeUndefined()
    })

    it('result.okがtrueの場合はundefinedを返すこと', () => {
      expect(findActionMessage({ ok: true })).toBeUndefined()
    })

    it('messageがある場合はそのメッセージを返すこと', () => {
      const result = {
        ok: false as const,
        message: 'global error',
        fieldErrors: [],
      }
      expect(findActionMessage(result)).toBe('global error')
    })

    it('messageがない場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
      }
      expect(
        findActionMessage(result as unknown as ActionResult),
      ).toBeUndefined()
    })
  })

  describe('createError', () => {
    it('issuesからエラーオブジェクトの配列を作成すること', () => {
      const issues = [
        {
          path: [{ key: 'email' }],
          message: 'invalid email',
        },
        {
          path: [{ key: 'password' }],
          message: 'too short',
        },
      ]
      const result = createError(
        issues as unknown as Parameters<typeof createError>[0],
      )
      expect(result).toEqual([
        { key: 'email', message: 'invalid email' },
        { key: 'password', message: 'too short' },
      ])
    })

    it('pathがない、またはkeyが文字列でない場合はスキップすること', () => {
      const issues = [
        {
          path: [],
          message: 'no path',
        },
        {
          path: [{ key: 123 }],
          message: 'invalid key type',
        },
      ]
      const result = createError(
        issues as unknown as Parameters<typeof createError>[0],
      )
      expect(result).toEqual([])
    })
  })
})
