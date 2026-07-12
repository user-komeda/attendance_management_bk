import { APIEvent } from '@solidjs/start/server/spa'

import getCurrentUserId from '~/lib/getCurrentUserId'
import { WorkSpaceWithMemberShips } from '~/schema/api/workSpaces'
import fetchWrapper from '~/util/fetchWrapper'

export const GET = async (event: APIEvent) => {
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

  const res = await fetchWrapper<WorkSpaceWithMemberShips>({
    path: `work_spaces/${slug}`,
    method: 'GET',
    userId,
  })

  if (!res.ok) {
    return new Response(JSON.stringify(res.error), {
      status: res.status,
    })
  }

  return new Response(JSON.stringify(res.data), { status: res.status })
}
