import { v4 as uuid } from 'uuid'
import { useSession } from 'vinxi/http'

import { redisSet } from '~/util/redisClient'

interface SessionData {
  sessionId: string
}
const createSession = async () => {
  const sessionId = uuid()
  const ttl = 60 * 60 * 24

  await redisSet(`session:${sessionId}`, sessionId, ttl)
  const session = await useSession<SessionData>({
    password: process.env.SESSION_PASSWORD!,
  })

  await session.update({
    sessionId: sessionId,
  })
  return session
}
export default createSession
