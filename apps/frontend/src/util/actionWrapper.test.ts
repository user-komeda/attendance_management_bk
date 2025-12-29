/* eslint-disable @typescript-eslint/no-explicit-any */

import * as v from 'valibot'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import actionWrapper from '~/util/actionWrapper'
import postWrapper from '~/util/postWrapper'

vi.mock('./postWrapper', () => ({
  default: vi.fn(),
}))

vi.mock('@solidjs/router', () => ({
  action: vi.fn((fn) => fn),
  redirect: vi.fn((url) => ({ type: 'redirect', url })),
}))

describe('actionWrapper', () => {
  const schema = v.object({
    name: v.pipe(v.string(), v.nonEmpty()),
  })

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should return errors if validation fails', async () => {
    const action = actionWrapper<typeof schema, any>(
      '/api/test',
      'test-action',
      schema,
    )
    const formData = new FormData()
    formData.append('name', '')

    const result = await action(formData)
    expect(result).toHaveProperty('error')
    expect(Array.isArray(result.error)).toBe(true)
  })

  it('should call postWrapper and return result if validation succeeds', async () => {
    const mockResponse = { success: true }
    vi.mocked(postWrapper).mockResolvedValueOnce(mockResponse)

    const action = actionWrapper('/api/test', 'test-action', schema)
    const formData = new FormData()
    formData.append('name', 'John')

    const result = await action(formData)
    expect(postWrapper).toHaveBeenCalledWith('/api/test', { name: 'John' })
    expect(result).toEqual(mockResponse)
  })

  it('should throw redirect if redirectUrl is provided', async () => {
    vi.mocked(postWrapper).mockResolvedValueOnce({ success: true })

    const action = actionWrapper('/api/test', 'test-action', schema, '/')
    const formData = new FormData()
    formData.append('name', 'John')

    try {
      await action(formData)
    } catch (e: any) {
      expect(e.type).toBe('redirect')
      expect(e.url).toBe('/')
    }
  })
})
