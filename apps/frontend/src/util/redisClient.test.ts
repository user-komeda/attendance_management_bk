/* eslint-disable @typescript-eslint/no-explicit-any */

import { createClient } from 'redis'
import { describe, it, expect, vi, beforeEach } from 'vitest'

vi.mock('redis', () => ({
  createClient: vi.fn(),
}))

describe('redisClient', () => {
  let mockClient: any

  beforeEach(async () => {
    vi.resetModules()
    vi.clearAllMocks()
    mockClient = {
      on: vi.fn(),
      connect: vi.fn().mockResolvedValue(undefined),
      setEx: vi.fn().mockResolvedValue('OK'),
      get: vi.fn().mockResolvedValue('test-value'),
      isOpen: false,
    }
    vi.mocked(createClient).mockReturnValue(mockClient)
  })

  it('getRedisClient should create and connect client', async () => {
    const { getRedisClient } = await import('./redisClient')
    const client = await getRedisClient()
    expect(createClient).toHaveBeenCalled()
    expect(mockClient.connect).toHaveBeenCalled()
    expect(client).toBe(mockClient)
  })

  it('getRedisClient should not recreate client if already exists', async () => {
    const { getRedisClient } = await import('./redisClient')
    await getRedisClient()
    mockClient.isOpen = true
    await getRedisClient()
    expect(createClient).toHaveBeenCalledTimes(1)
  })

  it('redisSet should call setEx', async () => {
    const { redisSet } = await import('./redisClient')
    await redisSet('key', 'value', 100)
    expect(mockClient.setEx).toHaveBeenCalledWith('key', 100, 'value')
  })

  it('redisGet should call get', async () => {
    const { redisGet } = await import('./redisClient')
    const value = await redisGet()
    expect(mockClient.get).toHaveBeenCalledWith('session_id')
    expect(value).toBe('test-value')
  })

  it('should log error when redis client emits error', async () => {
    const { getRedisClient } = await import('./redisClient')
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
    await getRedisClient()
    const errorCallback = mockClient.on.mock.calls.find(
      (call: any) => call[0] === 'error',
    )[1]
    errorCallback(new Error('Redis Error'))
    expect(consoleSpy).toHaveBeenCalledWith(
      'Redis Client Error',
      expect.any(Error),
    )
    consoleSpy.mockRestore()
  })
})
