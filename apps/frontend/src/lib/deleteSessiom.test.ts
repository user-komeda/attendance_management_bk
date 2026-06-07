import { describe, it, expect, vi } from 'vitest'

import deleteSession from '~/lib/deleteSessiom'
import * as redisClient from '~/util/redisClient'

vi.mock(import('~/util/redisClient'), () => ({
  redisDelete: vi.fn(),
  redisSMembers: vi.fn(),
}))

describe(deleteSession, () => {
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
})
