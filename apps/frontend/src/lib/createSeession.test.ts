/* eslint-disable @typescript-eslint/no-explicit-any */

import { useSession } from 'vinxi/http'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import createSession from '~/lib/createSeession'
import { redisSet } from '~/util/redisClient'

vi.mock(import('uuid'), () => ({
  v4: () => 'mock-uuid',
}))

vi.mock(import('~/util/redisClient'), () => ({
  redisSet: vi.fn(),
  redisSAdd: vi.fn(),
  redisExpire: vi.fn(),
}))

vi.mock(import('vinxi/http'), () => ({
  useSession: vi.fn(),
}))

 
describe(createSession, () => {
  beforeEach(() => {
    vi.clearAllMocks()
    process.env.SESSION_PASSWORD =
      'dJs3wmlkeHdFwul605ZWnDmlePyKGt/Q8XIMFDEySq4='
  })

  it('should create a session with uuid and store it in redis and session store', async () => {
    const mockSession = {
      update: vi.fn(),
    }
    vi.mocked(useSession).mockResolvedValue(mockSession as any)

    const userId = 'user123'
    const result = await createSession(userId)

    expect(redisSet).toHaveBeenCalledWith(
      'session:mock-uuid',
      userId,
      60 * 60 * 24,
    )
    expect(useSession).toHaveBeenCalledWith({
      password: 'dJs3wmlkeHdFwul605ZWnDmlePyKGt/Q8XIMFDEySq4=',
    })
    expect(mockSession.update).toHaveBeenCalledWith({
      sessionId: 'mock-uuid',
    })
    expect(result).toBe(mockSession)
  })

  it('redisSetが失敗した場合はエラーをスローすること', async () => {
    const { redisSet } = await import('~/util/redisClient')
    vi.mocked(redisSet).mockRejectedValue(new Error('redis error'))

    await expect(createSession('user123')).rejects.toThrow('redis error')
  })

  it('useSessionが失敗した場合はエラーをスローすること', async () => {
    const { redisSet } = await import('~/util/redisClient')
    vi.mocked(redisSet).mockResolvedValue(undefined)
    vi.mocked(useSession).mockRejectedValue(new Error('session error'))

    await expect(createSession('user123')).rejects.toThrow('session error')
  })
})
