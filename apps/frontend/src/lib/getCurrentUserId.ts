import { useSession } from 'vinxi/http'

import { getEnv } from '~/env'
import { redisGet } from '~/util/redisClient'

interface SessionData {
  sessionId?: string
}

const getCurrentUserId = async () => {
  const session = await useSession<SessionData>({
    password: getEnv().SESSION_PASSWORD,
  })

  const sessionId = session.data.sessionId

  if (!sessionId) {
    return null
  }

  const userId = await redisGet(`session:${sessionId}`)

  if (!userId) {
    return null
  }

  return userId
}

export default getCurrentUserId
