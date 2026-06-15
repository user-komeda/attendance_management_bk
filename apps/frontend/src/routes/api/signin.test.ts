import { APIEvent } from '@solidjs/start/server/spa'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import createSession from '~/lib/createSeession'
import { POST } from '~/routes/api/signin'
import fetchWrapper from '~/util/fetchWrapper'

vi.mock(import('~/util/fetchWrapper'))
vi.mock(import('~/lib/createSeession'))

describe('(signin) API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return 204 on successful (signin)', async () => {
    const mockEvent = {
      request: {
        json: async () => ({
          email: 'test@example.com',
          password: 'password123',
        }),
      },
    } as unknown as APIEvent

    vi.mocked(fetchWrapper).mockResolvedValue({
      ok: true,
      status: 200,
      data: { userId: 'user-123' },
    })
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    vi.mocked(createSession).mockResolvedValue({} as any)

    const response = await POST(mockEvent)

    expect(response.status).toBe(204)
    expect(fetchWrapper).toHaveBeenCalledWith('(signin)', 'POST', {
      email: 'test@example.com',
      password: 'password123',
    })
    expect(createSession).toHaveBeenCalledWith('user-123')
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
    expect(fetchWrapper).not.toHaveBeenCalled()
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

    vi.mocked(fetchWrapper).mockResolvedValue({
      ok: false,
      status: 500,
      error: { message: 'failed', fieldErrors: [] },
    })

    const response = await POST(mockEvent)
    const body = await response.json()

    expect(response.status).toBe(500)
    expect(body.message).toContain('failed')
  })

  it('should return 500 when userId is missing', async () => {
    const mockEvent = {
      request: {
        json: async () => ({
          email: 'test@example.com',
          password: 'password123',
        }),
      },
    } as unknown as APIEvent

    vi.mocked(fetchWrapper).mockResolvedValue({
      ok: true,
      status: 200,
      data: {},
    })

    const response = await POST(mockEvent)
    const body = await response.json()

    expect(response.status).toBe(500)
    expect(body.error).toContain('internal serverError')
  })
})
