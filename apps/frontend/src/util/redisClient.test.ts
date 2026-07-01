import { createClient } from 'redis'
import { describe, it, expect, vi, beforeEach } from 'vitest'

vi.mock(import('redis'), () => ({
  createClient: vi.fn(),
}))

vi.mock('~/env', () => ({
  getEnv: vi.fn().mockReturnValue({
    REDIS_URL: 'redis://default:password@localhost:6379/0',
  }),
}))

interface MockRedisClient {
  on: ReturnType<typeof vi.fn>
  connect: ReturnType<typeof vi.fn>
  setEx: ReturnType<typeof vi.fn>
  get: ReturnType<typeof vi.fn>
  isOpen: boolean
  del: ReturnType<typeof vi.fn>
  sAdd: ReturnType<typeof vi.fn>
  sMembers: ReturnType<typeof vi.fn>
  sRem: ReturnType<typeof vi.fn>
  expire: ReturnType<typeof vi.fn>
}

 
describe('redisClient', () => {
  let mockClient: MockRedisClient

  beforeEach(async () => {
    vi.resetModules()
    vi.clearAllMocks()
    mockClient = {
      on: vi.fn(),
      connect: vi.fn().mockResolvedValue(undefined),
      setEx: vi.fn().mockResolvedValue('OK'),
      get: vi.fn().mockResolvedValue('test-value'),
      isOpen: false,
      del: vi.fn(),
      sAdd: vi.fn(),
      sMembers: vi.fn(),
      sRem: vi.fn(),
      expire: vi.fn(),
    }
    vi.mocked(createClient).mockReturnValue(
      mockClient as unknown as ReturnType<typeof createClient>,
    )
  })

  it('getRedisClient should create and connect client', async () => {
    const { getRedisClient } = await import('./redisClient')
    const client = await getRedisClient()

    expect(createClient).toHaveBeenCalledWith({
      url: 'redis://default:password@localhost:6379/0',
    })
    expect(mockClient.connect).toHaveBeenCalledWith()
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
    const value = await redisGet('session_id')

    expect(mockClient.get).toHaveBeenCalledWith('session_id')
    expect(value).toBe('test-value')
  })

  it('should log error when redis client emits error', async () => {
    const { getRedisClient } = await import('./redisClient')
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
    await getRedisClient()
    const errorCallback = mockClient.on.mock.calls.find(
      (call: unknown[]) => call[0] === 'error',
    )?.[1] as (err: Error) => void
    errorCallback(new Error('Redis Error'))

    expect(consoleSpy).toHaveBeenCalledWith(
      'Redis Client Error',
      expect.any(Error),
    )

    consoleSpy.mockRestore()
  })

  it('redisDelete should call del', async () => {
    const { redisDelete } = await import('./redisClient')
    vi.spyOn(mockClient, 'del').mockResolvedValue(1)
    await redisDelete('key')

    expect(mockClient.del).toHaveBeenCalledWith('key')
  })

  it('redisSAdd should call sAdd', async () => {
    const { redisSAdd } = await import('./redisClient')
    vi.spyOn(mockClient, 'sAdd').mockResolvedValue(1)
    await redisSAdd('key', 'value')

    expect(mockClient.sAdd).toHaveBeenCalledWith('key', 'value')
  })

  it('redisSMembers should call sMembers', async () => {
    const { redisSMembers } = await import('./redisClient')
    vi.spyOn(mockClient, 'sMembers').mockResolvedValue(['v1'])
    const value = await redisSMembers('key')

    expect(mockClient.sMembers).toHaveBeenCalledWith('key')
    expect(value).toEqual(['v1'])
  })

  it('redisSRem should call sRem', async () => {
    const { redisSRem } = await import('./redisClient')
    vi.spyOn(mockClient, 'sRem').mockResolvedValue(1)
    await redisSRem('key', 'value')

    expect(mockClient.sRem).toHaveBeenCalledWith('key', 'value')
  })

  it('redisExpire should call expire', async () => {
    const { redisExpire } = await import('./redisClient')
    vi.spyOn(mockClient, 'expire').mockResolvedValue(1)
    await redisExpire('key', 10)

    expect(mockClient.expire).toHaveBeenCalledWith('key', 10)
  })
})
