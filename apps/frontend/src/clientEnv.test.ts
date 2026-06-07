import { describe, it, expect, beforeEach, vi } from 'vitest'

import { getEnv } from '~/clientEnv'

describe('clientEnv', () => {
  beforeEach(() => {
    vi.resetModules()
    process.env.VITE_API_URL = 'http://localhost:3000'
  })

  it('should return env variables when all are valid', () => {
    expect(getEnv()).toEqual({
      VITE_API_URL: 'http://localhost:3000',
    })
  })

  it('should throw an error when VITE_API_URL is invalid', () => {
    process.env.VITE_API_URL = 'invalid-url'

    expect(() => getEnv()).toThrow('Invalid frontend env')
  })

  it('should throw an error when all paths are missing', () => {
    process.env = {}

    expect(() => getEnv()).toThrow('Invalid frontend env')
  })
})
