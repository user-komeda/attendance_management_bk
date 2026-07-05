import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'

import bffFetchWrapper from '~/util/bffFetchWrapper'

describe(bffFetchWrapper, () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
  })

  afterEach(() => {
    vi.unstubAllGlobals()
  })

  it('should successfully fetch data', async () => {
    const mockData = { id: 1 }
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => mockData,
    } as Response)

    const result = await bffFetchWrapper({ path: '/api/test', method: 'GET' })

    expect(result).toEqual({
      ok: true,
      status: 200,
      data: mockData,
    })
  })

  it('should handle 204 No Content', async () => {
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 204,
    } as Response)

    const result = await bffFetchWrapper({
      path: '/api/test',
      method: 'DELETE',
    })

    expect(result).toEqual({
      ok: true,
      status: 204,
      data: undefined,
    })
  })

  it('should handle error response', async () => {
    const mockError = { message: 'error' }
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      status: 400,
      json: async () => mockError,
    } as Response)

    const result = await bffFetchWrapper({
      path: '/api/test',
      method: 'POST',
      data: { data: 1 },
    })

    expect(result).toEqual({
      ok: false,
      status: 400,
      error: mockError,
    })
  })

  it('should throw error when fetch fails', async () => {
    vi.mocked(fetch).mockRejectedValueOnce(new Error('network error'))

    await expect(
      bffFetchWrapper({ path: '/api/test', method: 'GET' }),
    ).rejects.toThrow('network error')
  })
})
