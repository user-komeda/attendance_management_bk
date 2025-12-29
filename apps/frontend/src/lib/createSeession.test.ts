/* eslint-disable @typescript-eslint/no-explicit-any */

import { useSession } from 'vinxi/http'
import { describe, it, expect, vi } from 'vitest'

import createSession from '~/lib/createSeession'
import { redisSet } from '~/util/redisClient'

vi.mock('uuid', () => ({
  v4: () => 'mock-uuid',
}))

vi.mock('~/util/redisClient', () => ({
  redisSet: vi.fn(),
}))

vi.mock('vinxi/http', () => ({
  useSession: vi.fn(),
}))

describe('createSession', () => {
  it('should create a session with uuid and store it in redis and session store', async () => {
    const mockSession = {
      update: vi.fn(),
    }
    vi.mocked(useSession).mockResolvedValue(mockSession as any)

    const result = await createSession()

    expect(redisSet).toHaveBeenCalledWith(
      'session:mock-uuid',
      'mock-uuid',
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
})
