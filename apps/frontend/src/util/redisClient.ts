import { createClient, RedisClientType } from 'redis'

import { getEnv } from '~/env'

let client: RedisClientType

export const getRedisClient = async () => {
  if (!client) {
    client = createClient({
      url: getEnv().REDIS_URL,
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

export const redisGet = async (key: string) => {
  const redis = await getRedisClient()
  return await redis.get(key)
}

export const redisDelete = async (key: string) => {
  const redis = await getRedisClient()
  await redis.del(key)
}

export const redisSAdd = async (key: string, value: string) => {
  const redis = await getRedisClient()
  await redis.sAdd(key, value)
}

export const redisSMembers = async (key: string) => {
  const redis = await getRedisClient()
  return await redis.sMembers(key)
}

export const redisSRem = async (key: string, value: string) => {
  const redis = await getRedisClient()
  await redis.sRem(key, value)
}

export const redisExpire = async (key: string, ttl: number) => {
  const redis = await getRedisClient()
  await redis.expire(key, ttl)
}
