import { describe, it, expect, beforeEach, vi } from 'vitest'

import { getEnv } from '~/env'

describe('env', () => {
  beforeEach(() => {
    vi.resetModules()
    process.env.API_URL = 'http://localhost:3000'
    process.env.SESSION_PASSWORD = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    process.env.JWT_SECRET = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    process.env.BFF_JWT_SECRET = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    process.env.JWT_ISSUER = 'test'
    process.env.JWT_AUDIENCE = 'test'
  })

  it('should return env variables when all are valid', () => {
    expect(getEnv()).toEqual({
      API_URL: 'http://localhost:3000',
      SESSION_PASSWORD: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      BFF_JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_ISSUER: 'test',
      JWT_AUDIENCE: 'test',
      REDIS_URL: expect.any(String),
    })
  })

  it('should throw an error when API_URL is invalid', () => {
    process.env.API_URL = 'invalid-url'

    expect(() => getEnv()).toThrow('Invalid frontend env')
  })

  it('should throw an error when all paths are missing', () => {
    process.env = {}

    expect(() => getEnv()).toThrow('Invalid frontend env')
  })
})
