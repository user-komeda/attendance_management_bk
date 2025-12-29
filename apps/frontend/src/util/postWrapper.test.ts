import { describe, it, expect, vi, beforeEach } from 'vitest'

import postWrapper from '~/util/postWrapper'

describe('postWrapper', () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
  })

  it('should successfully post data and return json', async () => {
    const mockResponse = { id: 1, name: 'test' }
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => mockResponse,
    } as Response)

    const result = await postWrapper('/api/test', { name: 'test' })
    expect(result).toEqual(mockResponse)
    expect(fetch).toHaveBeenCalledWith('/api/test', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'test' }),
    })
  })

  it('should return undefined for 204 No Content', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 204,
    } as Response)

    const result = await postWrapper('/api/test', { name: 'test' })
    expect(result).toBeUndefined()
  })

  it('should return undefined for 401 Unauthorized', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 401,
      text: async () => 'Unauthorized',
    } as Response)

    const result = await postWrapper('/api/test', { name: 'test' })
    expect(result).toBeUndefined()
  })

  it('should return undefined for 403 Forbidden', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 403,
      text: async () => 'Forbidden',
    } as Response)

    const result = await postWrapper('/api/test', { name: 'test' })
    expect(result).toBeUndefined()
  })

  it('should throw an error for other error statuses', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 500,
      text: async () => 'Internal Server Error',
    } as Response)

    await expect(postWrapper('/api/test', { name: 'test' })).rejects.toThrow(
      'POST error 500: Internal Server Error',
    )
  })
})
