import { SignJWT } from 'jose'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import * as env from '~/env'
import { createUserJwt, createBffJwt } from '~/lib/createJwt'

vi.mock(import('jose'), () => ({
  SignJWT: vi.fn().mockImplementation(function () {
    return {
      setProtectedHeader: vi.fn().mockReturnThis(),
      setIssuer: vi.fn().mockReturnThis(),
      setAudience: vi.fn().mockReturnThis(),
      setSubject: vi.fn().mockReturnThis(),
      setJti: vi.fn().mockReturnThis(),
      setIssuedAt: vi.fn().mockReturnThis(),
      setNotBefore: vi.fn().mockReturnThis(),
      setExpirationTime: vi.fn().mockReturnThis(),
      sign: vi.fn().mockResolvedValue('mock-jwt'),
    }
  }),
}))

describe('createJwt', () => {
  beforeEach(() => {
    vi.spyOn(env, 'getEnv').mockReturnValue({
      API_URL: 'http://localhost:4567',
      SESSION_PASSWORD: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      BFF_JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_ISSUER: 'test',
      JWT_AUDIENCE: 'test',
      REDIS_URL: 'redis://localhost:6379',
    })
  })

  it('should create user jwt', async () => {
    const jwt = await createUserJwt('user-1')

    expect(jwt).toBeTypeOf('string')
    expect(SignJWT).toHaveBeenCalledWith({ typ: 'access_token' })
    const instance = vi.mocked(SignJWT).mock.results[0].value
    expect(instance.setProtectedHeader).toHaveBeenCalledWith({
      alg: 'HS256',
      typ: 'USER_JWT',
    })
    expect(instance.setIssuer).toHaveBeenCalledWith('test')
    expect(instance.setAudience).toHaveBeenCalledWith('test')
    expect(instance.setSubject).toHaveBeenCalledWith('user-1')
  })

  it('should create bff jwt', async () => {
    vi.mocked(SignJWT).mockClear()
    const jwt = await createBffJwt()

    expect(jwt).toBeTypeOf('string')
    expect(SignJWT).toHaveBeenCalledWith({ typ: 'bff_assertion' })
    const instance = vi.mocked(SignJWT).mock.results[0].value
    expect(instance.setProtectedHeader).toHaveBeenCalledWith({
      alg: 'HS256',
      typ: 'BFF_JWT',
    })
    expect(instance.setIssuer).toHaveBeenCalledWith('test')
    expect(instance.setAudience).toHaveBeenCalledWith('test')
  })
})
