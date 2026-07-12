import { APIEvent } from '@solidjs/start/server/spa'
import * as v from 'valibot'

import getCurrentUserId from '~/lib/getCurrentUserId'
import { CreateContentApiWithFieldsSchema } from '~/schema/contentApi/createContentApiWithFieldsSchhema'
import { createError } from '~/util/error'
import fetchWrapper from '~/util/fetchWrapper'

// eslint-disable-next-line max-lines-per-function
export const POST = async (event: APIEvent) => {
  const userId = await getCurrentUserId()

  if (!userId) {
    return new Response(JSON.stringify({ error: ['unauthorized'] }), {
      status: 401,
    })
  }

  const slug = event.params.slug

  if (!slug) {
    return new Response(
      JSON.stringify({ error: ['workspace slug is required'] }),
      {
        status: 400,
      },
    )
  }

  const body = await event.request.json()
  const result = v.safeParse(CreateContentApiWithFieldsSchema, body)

  if (!result.success) {
    return new Response(JSON.stringify({ error: createError(result.issues) }), {
      status: 400,
    })
  }

  const res = await fetchWrapper({
    path: `work_spaces/${slug}/content_api`,
    method: 'POST',
    data: {
      name: result.output.name,
      endpoint: result.output.endpoint,
      apiType: result.output.apiType,
      fields: result.output.fields,
    },
    userId,
  })
  if (!res.ok) {
    return new Response(JSON.stringify(res.error), {
      status: res.status,
    })
  }

  return new Response(JSON.stringify(res.data), { status: res.status })
}
