import { APIEvent } from '@solidjs/start/server/spa'

import getCurrentUserId from '~/lib/getCurrentUserId'

export const GET = async () => {
  const userId = await getCurrentUserId()

  if (!userId) {
    return new Response(
      JSON.stringify({
        authenticated: false,
      }),
      {
        status: 401,
      },
    )
  }

  return new Response(
    JSON.stringify({
      authenticated: true,
    }),
    {
      status: 200,
    },
  )
}
