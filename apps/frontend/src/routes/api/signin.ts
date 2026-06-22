import { APIEvent } from '@solidjs/start/server/spa'
import * as v from 'valibot'

import createSession from '~/lib/createSeession'
import { SigninSchema } from '~/schema/signinSchema'
import { createError } from '~/util/error'
import fetchWrapper from '~/util/fetchWrapper'

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

  const res = await fetchWrapper<{ userId: string }>({
    path: 'signin',
    method: 'POST',
    data: requestBody,
  })

  if (!res.ok) {
    return new Response(JSON.stringify(res.error), {
      status: res.status,
    })
  }

  if (!res.data?.userId) {
    return new Response(JSON.stringify({ error: ['internal serverError'] }), {
      status: 500,
    })
  }

  await createSession(res.data.userId)

  return new Response(null, { status: 204 })
}
