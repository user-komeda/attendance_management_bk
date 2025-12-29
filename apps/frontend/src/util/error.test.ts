/* eslint-disable @typescript-eslint/no-explicit-any */

import * as v from 'valibot'
import { describe, it, expect } from 'vitest'

import { findError, createError } from '~/util/error'

describe('error util', () => {
  describe('findError', () => {
    it('should find the error message for a given key', () => {
      const errors = [
        { key: 'email', message: 'Invalid email' },
        { key: 'password', message: 'Too short' },
      ]
      expect(findError(errors, 'email')).toBe('Invalid email')
      expect(findError(errors, 'password')).toBe('Too short')
    })

    it('should return undefined if the key is not found', () => {
      const errors = [{ key: 'email', message: 'Invalid email' }]
      expect(findError(errors, 'password')).toBeUndefined()
    })
  })

  describe('createError', () => {
    it('should transform valibot issues into custom error objects', () => {
      const schema = v.object({
        email: v.pipe(v.string(), v.email('Invalid email')),
        password: v.pipe(v.string(), v.minLength(8, 'Too short')),
      })

      const result = v.safeParse(schema, { email: 'invalid', password: '123' })
      if (!result.success) {
        const errors = createError<typeof schema>(result.issues as any)
        expect(errors).toEqual([
          { key: 'email', message: 'Invalid email' },
          { key: 'password', message: 'Too short' },
        ])
      } else {
        throw new Error('Validation should have failed')
      }
    })
  })
})
