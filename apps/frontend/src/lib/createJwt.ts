import { SignJWT } from 'jose'
import { v4 as uuid } from 'uuid'

import { getEnv } from '~/env'

const encoder = new TextEncoder()

const USER_JWT_EXPIRES_IN_SECONDS = 60
const BFF_JWT_EXPIRES_IN_SECONDS = 60

export const createUserJwt = async (userId: string) => {
  const env = getEnv()
  const secret = encoder.encode(env.JWT_SECRET)
  const now = Math.floor(Date.now() / 1000)

  return new SignJWT({
    typ: 'access_token',
  })
    .setProtectedHeader({ alg: 'HS256', typ: 'USER_JWT' })
    .setIssuer(env.JWT_ISSUER)
    .setAudience(env.JWT_AUDIENCE)
    .setSubject(userId)
    .setJti(uuid())
    .setIssuedAt(now)
    .setNotBefore(now)
    .setExpirationTime(now + USER_JWT_EXPIRES_IN_SECONDS)
    .sign(secret)
}

export const createBffJwt = async () => {
  const env = getEnv()
  const secret = encoder.encode(env.BFF_JWT_SECRET)
  const now = Math.floor(Date.now() / 1000)

  return new SignJWT({
    typ: 'bff_assertion',
  })
    .setProtectedHeader({ alg: 'HS256', typ: 'BFF_JWT' })
    .setIssuer(env.JWT_ISSUER)
    .setAudience(env.JWT_AUDIENCE)
    .setIssuedAt(now)
    .setNotBefore(now)
    .setExpirationTime(now + BFF_JWT_EXPIRES_IN_SECONDS)
    .sign(secret)
}
