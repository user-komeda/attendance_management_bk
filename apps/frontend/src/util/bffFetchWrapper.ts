import { FetchResult } from '~/types/fetch'

type HttpMethod = 'GET' | 'POST' | 'DELETE' | 'PATCH' | 'PUT'

const bffFetchWrapper = async <R, ErrorKey extends string = string>(
  path: string,
  method: HttpMethod,
  data?: unknown,
): Promise<FetchResult<R, ErrorKey>> => {
  const res = await fetch(path, {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
    body: data === undefined ? undefined : JSON.stringify(data),
  }).catch((error) => {
    console.error('Error:', error)
    throw error
  })

  const responseData = res.status === 204 ? undefined : await res.json()
  if (!res.ok) {
    return {
      ok: false,
      status: res.status,
      error: responseData,
    }
  }

  return {
    ok: true,
    status: res.status,
    data: responseData as R | undefined,
  }
}

export default bffFetchWrapper
