import * as v from 'valibot'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { ApiActionError } from '~/types/fetch'
import actionWrapper from '~/util/actionWrapper'
import bffFetchWrapper from '~/util/bffFetchWrapper'

vi.mock(import('~/util/bffFetchWrapper'), () => ({
  default: vi.fn(),
}))

vi.mock('@solidjs/router', () => ({
  action: vi.fn((fn) => fn),
  redirect: vi.fn((url) => ({ type: 'redirect', url })),
}))

describe(actionWrapper, () => {
  const schema = v.object({
    name: v.pipe(v.string(), v.nonEmpty()),
  })

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return errors if validation fails', async () => {
    const action = actionWrapper<typeof schema>({
      path: '/api/test',
      method: 'POST',
      schema,
    })
    const formData = new FormData()
    formData.append('name', '')

    const result = await action(formData)
    if (!result || result.ok) {
      throw new Error('Expected result to be ok: false')
    }

    expect(result).toBeDefined()
    expect(result).toHaveProperty('fieldErrors')
    expect(Array.isArray(result.fieldErrors)).toBe(true)
  })

  it('should call bffFetchWrapper and return result if validation succeeds', async () => {
    const mockResponse = { success: true }
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({
      ok: true,
      status: 200,
      data: mockResponse,
    })

    const action = actionWrapper({
      path: '/api/test',
      method: 'POST',
      schema,
    })
    const formData = new FormData()
    formData.append('name', 'John')

    const result = await action(formData)

    expect(bffFetchWrapper).toHaveBeenCalledWith({
      path: '/api/test',
      method: 'POST',
      data: { name: 'John' },
    })
    expect(result).toEqual({ ok: true })
  })

  it('should throw redirect if redirectUrl is provided', async () => {
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({
      ok: true,
      status: 200,
      data: { success: true },
    })

    const action = actionWrapper({
      path: '/api/test',
      method: 'POST',
      schema,
      redirectUrl: '/',
    })
    const formData = new FormData()
    formData.append('name', 'John')

    let caughtError: { type?: string; url?: string } | null = null
    try {
      await action(formData)
    } catch (e) {
      caughtError = e as { type?: string; url?: string }
    }

    expect(caughtError).not.toBeNull()
    expect(caughtError?.type).toBe('redirect')
    expect(caughtError?.url).toBe('/')
  })

  it('should return error if bffFetchWrapper fails', async () => {
    const mockError: ApiActionError<'name'> = {
      message: 'failed',
      fieldErrors: [],
    }
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({
      ok: false,
      status: 500,
      error: mockError,
    })

    const action = actionWrapper({
      path: '/api/test',
      method: 'POST',
      schema,
    })
    const formData = new FormData()
    formData.append('name', 'John')

    const result = await action(formData)

    expect(result).toEqual({
      ok: false,
      ...mockError,
    })
  })
})
