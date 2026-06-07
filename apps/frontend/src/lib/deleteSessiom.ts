import { redisDelete, redisSMembers } from '~/util/redisClient'

const deleteSession = async (userId: string) => {
  const userSessionsKey = `user_sessions:${userId}`
  const sessionIds = await redisSMembers(userSessionsKey)

  await Promise.all(
    sessionIds.map((sessionId) => redisDelete(`session:${sessionId}`)),
  )

  await redisDelete(userSessionsKey)
}

export default deleteSession
