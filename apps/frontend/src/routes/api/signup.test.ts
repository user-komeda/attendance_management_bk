/* eslint-disable @typescript-eslint/no-explicit-any */

import { describe, it, expect, vi, beforeEach } from 'vitest'


import createSession from '~/lib/createSeession'
import { POST } from '~/routes/api/signup'
import postWrapper from '~/util/postWrapper'

vi.mock('~/util/postWrapper')
vi.mock('~/lib/createSeession')

describe('Signup API', () => {
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

    vi.mocked(postWrapper).mockResolvedValueOnce({ user_id: '123' })
    vi.mocked(createSession).mockResolvedValueOnce({} as any)

    const response = await POST(mockEvent)
    expect(response.status).toBe(204)
    expect(postWrapper).toHaveBeenCalledWith(
      'http://localhost:4567/signup',
      {
        email: 'john@example.com',
        password: 'password123',
        first_name: 'John',
        last_name: 'Doe',
      }
    )
    expect(createSession).toHaveBeenCalled()
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

  it('should return 500 if postWrapper fails to return user_id', async () => {
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

    vi.mocked(postWrapper).mockResolvedValueOnce(null)

    const response = await POST(mockEvent)
    expect(response.status).toBe(500)
    const body = await response.json()
    expect(body.error).toContain('internal serverError')
  })
})
