import { APIEvent } from '@solidjs/start/server/spa'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import createSession from '~/lib/createSeession'
import { POST } from '~/routes/api/signin'
import postWrapper from '~/util/postWrapper'

vi.mock('~/util/postWrapper')
vi.mock('~/lib/createSeession')

describe('signin API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return 204 on successful signin', async () => {
    const mockEvent = {
      request: {
        json: async () => ({
          email: 'test@example.com',
          password: 'password123',
        }),
      },
    } as unknown as APIEvent

    vi.mocked(postWrapper).mockResolvedValue({ user_id: 'user-123' })
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    vi.mocked(createSession).mockResolvedValue({} as any)

    const response = await POST(mockEvent)

    expect(response.status).toBe(204)
    expect(postWrapper).toHaveBeenCalledWith('http://localhost:4567/signin', {
      email: 'test@example.com',
      password: 'password123',
    })
    expect(createSession).toHaveBeenCalled()
  })

  it('should return 400 on validation failure', async () => {
    const mockEvent = {
      request: {
        json: async () => ({
          email: 'invalid-email',
          password: 'short',
        }),
      },
    } as unknown as APIEvent

    const response = await POST(mockEvent)
    const body = await response.json()

    expect(response.status).toBe(400)
    expect(body.error).toBeDefined()
    expect(postWrapper).not.toHaveBeenCalled()
  })

  it('should return 500 when backend request fails', async () => {
    const mockEvent = {
      request: {
        json: async () => ({
          email: 'test@example.com',
          password: 'password123',
        }),
      },
    } as unknown as APIEvent

    vi.mocked(postWrapper).mockResolvedValue(null)

    const response = await POST(mockEvent)
    const body = await response.json()

    expect(response.status).toBe(500)
    expect(body.error).toContain('internal serverError')
  })
})
