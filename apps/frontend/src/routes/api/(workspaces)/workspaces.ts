import { APIEvent } from '@solidjs/start/server/spa'
import * as v from 'valibot'

import getCurrentUserId from '~/lib/getCurrentUserId'
import {
  ListWorkSpacesResponse,
  WorkSpaceWithMemberShips,
} from '~/schema/api/workSpaces'
import { CreateWorkspaceSchema } from '~/schema/workspace/createWorkspaceSchema'
import { createError } from '~/util/error'
import fetchWrapper from '~/util/fetchWrapper'

const buildWorkSpacesQuery = (searchParams: URLSearchParams) => {
  const query = new URLSearchParams()

  const page = searchParams.get('page')
  const perPage = searchParams.get('per_page')
  const searchQuery = searchParams.get('search_query')

  if (page) {
    query.set('page', page)
  }

  if (perPage) {
    query.set('per_page', perPage)
  }

  if (searchQuery) {
    query.set('search_query', searchQuery)
  }

  return query.toString()
}

const buildWorkSpacesPath = (requestUrl: string) => {
  const searchParams = new URL(requestUrl).searchParams
  const query = buildWorkSpacesQuery(searchParams)

  return query ? `work_spaces?${query}` : 'work_spaces'
}

export const GET = async (event: APIEvent) => {
  const userId = await getCurrentUserId()
  if (!userId) {
    return new Response(
      JSON.stringify({
        error: ['unauthorized'],
      }),
      {
        status: 401,
      },
    )
  }

  const res = await fetchWrapper<ListWorkSpacesResponse>({
    path: buildWorkSpacesPath(event.request.url),
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

export const POST = async (event: APIEvent) => {
  const userId = await getCurrentUserId()

  if (!userId) {
    return new Response(JSON.stringify({ error: ['unauthorized'] }), {
      status: 401,
    })
  }

  const body = await event.request.json()
  const result = v.safeParse(CreateWorkspaceSchema, body)
  if (!result.success) {
    return new Response(JSON.stringify({ error: createError(result.issues) }), {
      status: 400,
    })
  }

  const res = await fetchWrapper<WorkSpaceWithMemberShips>({
    path: 'work_spaces',
    method: 'POST',
    data: {
      name: result.output.name,
      slug: result.output.slug,
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
