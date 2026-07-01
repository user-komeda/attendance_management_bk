/* eslint-disable @typescript-eslint/no-explicit-any */

import { describe, it, expect, vi, beforeEach } from 'vitest'

import createSession from '~/lib/createSeession'
import { POST } from '~/routes/api/signup'
import fetchWrapper from '~/util/fetchWrapper'

vi.mock(import('~/util/fetchWrapper'))
vi.mock(import('~/lib/createSeession'))

 
describe('signup API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return 204 on successful signup', async () => {
    const mockRequest = {
      json: async () => ({
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      }),
    }
    const mockEvent = { request: mockRequest } as any

    vi.mocked(fetchWrapper).mockResolvedValueOnce({
      ok: true,
      status: 200,
      data: { userId: '123' },
    })
    vi.mocked(createSession).mockResolvedValueOnce({} as any)

    const response = await POST(mockEvent)

    expect(response.status).toBe(204)
    expect(fetchWrapper).toHaveBeenCalledWith({
      path: 'signup',
      method: 'POST',
      data: {
        email: 'john@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe',
      },
    })
    expect(createSession).toHaveBeenCalledWith('123')
  })

  it('should return 400 if validation fails', async () => {
    const mockRequest = {
      json: async () => ({
        firstName: '', // invalid
        email: 'invalid-email',
      }),
    }
    const mockEvent = { request: mockRequest } as any

    const response = await POST(mockEvent)

    expect(response.status).toBe(400)

    const body = await response.json()

    expect(body.error).toBeDefined()
  })

  it('should return 500 if fetchWrapper fails to return user_id', async () => {
    const mockRequest = {
      json: async () => ({
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      }),
    }
    const mockEvent = { request: mockRequest } as any

    vi.mocked(fetchWrapper).mockResolvedValueOnce({
      ok: false,
      status: 500,
      error: { message: 'failed', fieldErrors: [] } as any,
    })

    const response = await POST(mockEvent)

    expect(response.status).toBe(500)

    const body = await response.json()

    expect(body.message).toContain('failed')
  })

  it('should return 500 when userId is missing in success response', async () => {
    const mockRequest = {
      json: async () => ({
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      }),
    }
    const mockEvent = { request: mockRequest } as any

    vi.mocked(fetchWrapper).mockResolvedValueOnce({
      ok: true,
      status: 200,
      data: {} as any,
    })

    const response = await POST(mockEvent)

    expect(response.status).toBe(500)

    const body = await response.json()

    expect(body.error).toContain('internal serverError')
  })
})
