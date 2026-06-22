import { useSession } from 'vinxi/http'
import { describe, it, expect, vi } from 'vitest'

import getCurrentUserId from '~/lib/getCurrentUserId'
import { redisGet } from '~/util/redisClient'

vi.mock('vinxi/http', () => ({
  useSession: vi.fn(),
}))

vi.mock('~/util/redisClient', () => ({
  redisGet: vi.fn(),
}))

vi.mock('~/env', () => ({
  getEnv: vi.fn().mockReturnValue({
    SESSION_PASSWORD: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  }),
}))

describe('getCurrentUserId', () => {
  it('sessionIdがない場合はnullを返すこと', async () => {
    vi.mocked(useSession).mockResolvedValue({
      data: {},
    } as unknown as Awaited<ReturnType<typeof useSession>>)

    const result = await getCurrentUserId()
    expect(result).toBeNull()
  })

  it('userIdがredisにない場合はnullを返すこと', async () => {
    vi.mocked(useSession).mockResolvedValue({
      data: { sessionId: 'session-id' },
    } as unknown as Awaited<ReturnType<typeof useSession>>)
    vi.mocked(redisGet).mockResolvedValue(null)

    const result = await getCurrentUserId()
    expect(result).toBeNull()
    expect(redisGet).toHaveBeenCalledWith('session:session-id')
  })

  it('userIdがある場合はuserIdを返すこと', async () => {
    vi.mocked(useSession).mockResolvedValue({
      data: { sessionId: 'session-id' },
    } as unknown as Awaited<ReturnType<typeof useSession>>)
    vi.mocked(redisGet).mockResolvedValue('user-id')

    const result = await getCurrentUserId()
    expect(result).toBe('user-id')
  })
})
