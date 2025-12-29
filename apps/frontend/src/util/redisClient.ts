import { createClient, RedisClientType } from 'redis'

let client: RedisClientType

export const getRedisClient = async () => {
  if (!client) {
    client = createClient({
      url: 'redis://default:password@localhost:6379/0',
    })

    client.on('error', (err) => {
      console.error('Redis Client Error', err)
    })
  }

  if (!client.isOpen) {
    await client.connect()
  }

  return client
}
export const redisSet = async (key: string, value: string, ttl: number) => {
  const redis = await getRedisClient()
  await redis.setEx(key, ttl, value)
}

export const redisGet = async () => {
  const redis = await getRedisClient()
  return await redis.get('session_id')
}
