import { describe, it, expect, vi, beforeEach } from 'vitest'

import bffFetchWrapper from '~/util/bffFetchWrapper'

describe(bffFetchWrapper, () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', vi.fn())
  })

  it('should successfully fetch data', async () => {
    const mockData = { id: 1 }
    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      status: 200,
      json: async () => mockData,
    } as Response)

    const result = await bffFetchWrapper('/api/test', 'GET')

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

    const result = await bffFetchWrapper('/api/test', 'DELETE')

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

    const result = await bffFetchWrapper('/api/test', 'POST', { data: 1 })

    expect(result).toEqual({
      ok: false,
      status: 400,
      error: mockError,
    })
  })

  it('should throw error when fetch fails', async () => {
    vi.mocked(fetch).mockRejectedValueOnce(new Error('network error'))

    await expect(bffFetchWrapper('/api/test', 'GET')).rejects.toThrow(
      'network error',
    )
  })
})
