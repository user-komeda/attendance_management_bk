import { v4 as uuid } from 'uuid'
import { useSession } from 'vinxi/http'

import { redisExpire, redisSet, redisSAdd } from '~/util/redisClient'

interface SessionData {
  sessionId: string
}

const SESSION_TTL_SECONDS = 60 * 60 * 24

const createSession = async (userId: string) => {
  const sessionId = uuid()
  const sessionKey = `session:${sessionId}`
  const userSessionsKey = `user_sessions:${userId}`

  await redisSet(sessionKey, userId, SESSION_TTL_SECONDS)
  await redisSAdd(userSessionsKey, sessionId)
  await redisExpire(userSessionsKey, SESSION_TTL_SECONDS)

  const session = await useSession<SessionData>({
    password: process.env.SESSION_PASSWORD!,
  })

  await session.update({
    sessionId,
  })

  return session
}

export default createSession
