import { describe, it, expect, vi, beforeEach } from 'vitest'

import * as env from '~/env'
import * as createJwt from '~/lib/createJwt'
import fetchWrapper from '~/util/fetchWrapper'

describe(fetchWrapper, () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
    vi.spyOn(createJwt, 'createBffJwt').mockResolvedValue('mock-bff-jwt')
    vi.spyOn(createJwt, 'createUserJwt').mockResolvedValue('mock-user-jwt')
    vi.spyOn(env, 'getEnv').mockReturnValue({
      API_URL: 'http://localhost:4567',
      SESSION_PASSWORD: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      BFF_JWT_SECRET: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      JWT_ISSUER: 'test',
      JWT_AUDIENCE: 'test',
    })
  })

  it('should successfully post data and return json', async () => {
    const mockResponse = { id: 1, name: 'test' }
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => mockResponse,
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: true,
      status: 200,
      data: mockResponse,
    })
    expect(fetch).toHaveBeenCalledWith('http://localhost:4567/signin', {
      method: 'POST',
      headers: expect.any(Headers),
      body: JSON.stringify({ name: 'test' }),
    })
  })

  it('should return undefined for 204 No Content', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 204,
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: true,
      status: 204,
      data: undefined,
    })
  })

  it('should return undefined for 401 Unauthorized', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 401,
      json: async () => ({ message: 'Unauthorized', fieldErrors: [] }),
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: false,
      status: 401,
      error: { message: 'Unauthorized', fieldErrors: [] },
    })
  })

  it('should return undefined for 403 Forbidden', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 403,
      json: async () => ({ message: 'Forbidden', fieldErrors: [] }),
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: false,
      status: 403,
      error: { message: 'Forbidden', fieldErrors: [] },
    })
  })

  it('should throw an error for other error statuses', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 500,
      json: async () => ({ message: 'Internal Server Error', fieldErrors: [] }),
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: false,
      status: 500,
      error: { message: 'Internal Server Error', fieldErrors: [] },
    })
  })

  it('should convert request keys to snake case', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => ({}),
    } as Response)

    await fetchWrapper('signin', 'POST', {
      userName: 'test',
      items: [{ itemName: 'test' }],
    })

    expect(fetch).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        body: JSON.stringify({
          user_name: 'test',
          items: [{ item_name: 'test' }],
        }),
      }),
    )
  })

  it('should handle null data', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => ({}),
    } as Response)

    await fetchWrapper('signin', 'POST', null)

    expect(fetch).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({
        body: JSON.stringify(null),
      }),
    )
  })

  it('should throw error if userId is missing for private path', async () => {
    await expect(fetchWrapper('private', 'GET')).rejects.toThrow(
      'User id is required',
    )
  })

  it('should call createUserJwt for private path with userId', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => ({}),
    } as Response)

    await fetchWrapper('private', 'GET', undefined, 'user-123')

    expect(createJwt.createUserJwt).toHaveBeenCalledWith('user-123')
  })

  it('should call createBffJwt for signup path', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => ({}),
    } as Response)

    await fetchWrapper('signup', 'POST', { name: 'test' })

    expect(createJwt.createBffJwt).toHaveBeenCalledWith()
  })

  it('should convert response keys to camel case', async () => {
    const mockResponse = {
      user_name: 'test',
      items: [{ item_name: 'test' }],
    }

    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => mockResponse,
    } as Response)

    const result = await fetchWrapper('signin', 'POST', { name: 'test' })

    expect(result).toEqual({
      ok: true,
      status: 200,
      data: {
        userName: 'test',
        items: [{ itemName: 'test' }],
      },
    })
  })
})
