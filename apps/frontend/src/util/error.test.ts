/* eslint-disable max-lines */
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

    it('ルートキーが文字列でない場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [{ key: 'items', message: 'invalid items' }],
        message: 'error',
      }

      expect(findError(result, '0[name]')).toBeUndefined()
    })

    it('path付きエラーが一致する場合はメッセージを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [
          {
            key: 'items',
            path: [{ key: 'items' }, { key: 0 }, { key: 'name' }],
            message: 'name is required',
          },
        ],
        message: 'error',
      }

      expect(findError(result, 'items[0][name]')).toBe('name is required')
    })

    it('path付きエラーが一致しない場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [
          {
            key: 'items',
            path: [{ key: 'items' }, { key: 1 }, { key: 'name' }],
            message: 'name is required',
          },
        ],
        message: 'error',
      }

      expect(findError(result, 'items[0][name]')).toBeUndefined()
    })

    it('pathなしエラーでnameとkeyが不一致の場合はundefinedを返すこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [{ key: 'email', message: 'invalid email' }],
        message: 'error',
      }

      expect(findError(result, 'email[address]')).toBeUndefined()
    })

    it('配列インデックスの先頭ゼロは文字列キーとして扱うこと', () => {
      const result = {
        ok: false as const,
        fieldErrors: [
          {
            key: 'items',
            path: [{ key: 'items' }, { key: '01' }, { key: 'name' }],
            message: 'name is required',
          },
        ],
        message: 'error',
      }

      expect(findError(result, 'items[01][name]')).toBe('name is required')
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
        { key: 'email', path: [{ key: 'email' }], message: 'invalid email' },
        {
          key: 'password',
          path: [{ key: 'password' }],
          message: 'too short',
        },
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

    it('issue.pathがundefinedの場合はpathなしのエラーを返すこと', () => {
      const issues = [
        {
          path: [{ key: 'email' }],
          message: 'invalid email',
        },
        {
          message: 'unexpected',
        },
      ]

      const result = createError(
        issues as unknown as Parameters<typeof createError>[0],
      )

      expect(result).toEqual([
        { key: 'email', path: [{ key: 'email' }], message: 'invalid email' },
      ])
    })

    it('path内のkeyが文字列/数値以外の場合は除外すること', () => {
      const issues = [
        {
          path: [{ key: 'items' }, { key: { nested: true } }, { key: 0 }],
          message: 'invalid path',
        },
      ]

      const result = createError(
        issues as unknown as Parameters<typeof createError>[0],
      )

      expect(result).toEqual([
        {
          key: 'items',
          path: [{ key: 'items' }, { key: 0 }],
          message: 'invalid path',
        },
      ])
    })

    it('issue.pathがundefinedの場合は空配列を返すこと', () => {
      const issues = [
        {
          message: 'unexpected',
        },
      ]

      const result = createError(
        issues as unknown as Parameters<typeof createError>[0],
      )

      expect(result).toEqual([])
    })
  })
})
