 

import * as v from 'valibot'
import { describe, it, expect } from 'vitest'

import SignupSchema from '~/schema/signupSchema'

describe('SignupSchema', () => {
  it('should validate valid data', () => {
    const validData = {
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'password123',
      confirmPassword: 'password123',
    }
    const result = v.safeParse(SignupSchema, validData)
    expect(result.success).toBe(true)
  })

  it('should fail if firstName is empty', () => {
    const invalidData = {
      firstName: '',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'password123',
      confirmPassword: 'password123',
    }
    const result = v.safeParse(SignupSchema, invalidData)
    expect(result.success).toBe(false)
  })

  it('should fail if email is invalid', () => {
    const invalidData = {
      firstName: 'John',
      lastName: 'Doe',
      email: 'invalid-email',
      password: 'password123',
      confirmPassword: 'password123',
    }
    const result = v.safeParse(SignupSchema, invalidData)
    expect(result.success).toBe(false)
  })

  it('should fail if password is too short', () => {
    const invalidData = {
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'short',
      confirmPassword: 'short',
    }
    const result = v.safeParse(SignupSchema, invalidData)
    expect(result.success).toBe(false)
  })

  it('should fail if passwords do not match', () => {
    const invalidData = {
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'password123',
      confirmPassword: 'different123',
    }
    const result = v.safeParse(SignupSchema, invalidData)
    expect(result.success).toBe(false)
    if (!result.success) {
      expect(result.issues[0].message).toBe('The two passwords do not match.')
    }
  })
})
