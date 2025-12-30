import { APIEvent } from '@solidjs/start/server/spa'
import * as v from 'valibot'

import createSession from '~/lib/createSeession'
import { SigninSchema } from '~/schema/signinSchema'
import { createError } from '~/util/error'
import postWrapper from '~/util/postWrapper'

export const POST = async (event: APIEvent) => {
  const body = await event.request.json()
  const result = v.safeParse(SigninSchema, body)
  if (!result.success) {
    return new Response(JSON.stringify({ error: createError(result.issues) }), {
      status: 400,
    })
  }

  const requestBody = {
    email: result.output.email,
    password: result.output.password,
  }
  const res = await postWrapper<{ user_id: string }>(
    'http://localhost:4567/signin',
    requestBody,
  )
  if (!res?.user_id) {
    return new Response(JSON.stringify({ error: ['internal serverError'] }), {
      status: 500,
    })
  }
  await createSession()

  return new Response(null, { status: 204 })
}
