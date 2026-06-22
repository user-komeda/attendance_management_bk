import { describe, it, expect, vi, beforeEach } from 'vitest'

import deleteSession from '~/lib/deleteSessiom'
import * as redisClient from '~/util/redisClient'

vi.mock(import('~/util/redisClient'), () => ({
  redisDelete: vi.fn(),
  redisSMembers: vi.fn(),
}))

describe(deleteSession, () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should delete sessions', async () => {
    vi.mocked(redisClient.redisSMembers).mockResolvedValue(['s1', 's2'])

    await deleteSession('user-1')

    expect(redisClient.redisSMembers).toHaveBeenCalledWith(
      'user_sessions:user-1',
    )
    expect(redisClient.redisDelete).toHaveBeenCalledWith('session:s1')
    expect(redisClient.redisDelete).toHaveBeenCalledWith('session:s2')
    expect(redisClient.redisDelete).toHaveBeenCalledWith('user_sessions:user-1')
  })

  it('セッションが存在しない場合はuser_sessionsキーのみ削除すること', async () => {
    vi.mocked(redisClient.redisSMembers).mockResolvedValue([])

    await deleteSession('user-1')

    expect(redisClient.redisSMembers).toHaveBeenCalledWith(
      'user_sessions:user-1',
    )
    expect(redisClient.redisDelete).toHaveBeenCalledTimes(1)
    expect(redisClient.redisDelete).toHaveBeenCalledWith('user_sessions:user-1')
  })

  it('redisSMembersが失敗した場合はエラーをスローすること', async () => {
    vi.mocked(redisClient.redisSMembers).mockRejectedValue(
      new Error('redis error'),
    )

    await expect(deleteSession('user-1')).rejects.toThrow('redis error')
  })
})
