import { getEnv } from '~/env'
import { createBffJwt, createUserJwt } from '~/lib/createJwt'
import { ApiActionError, FetchResult } from '~/types/fetch'

const PUBLIC_API_PATHS = ['signin', 'signup']

const camelToSnake = (value: string) => {
  return value.replace(/[A-Z]/g, (char) => `_${char.toLowerCase()}`)
}

const snakeToCamel = (value: string) => {
  return value.replace(/_([a-z])/g, (_, char: string) => char.toUpperCase())
}

const convertKeysToSnakeCase = (value: unknown): unknown => {
  if (Array.isArray(value)) {
    return value.map(convertKeysToSnakeCase)
  }

  if (value !== null && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value).map(([key, nestedValue]) => [
        camelToSnake(key),
        convertKeysToSnakeCase(nestedValue),
      ]),
    )
  }

  return value
}

const convertKeysToCamelCase = (value: unknown): unknown => {
  if (Array.isArray(value)) {
    return value.map(convertKeysToCamelCase)
  }

  if (value !== null && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value).map(([key, nestedValue]) => [
        snakeToCamel(key),
        convertKeysToCamelCase(nestedValue),
      ]),
    )
  }

  return value
}

const buildHeaders = async (path: string, userId?: string) => {
  const headers = new Headers()

  if (PUBLIC_API_PATHS.includes(path)) {
    headers.set('Authorization', `Bearer ${await createBffJwt()}`)
  } else {
    if (!userId) throw new Error('User id is required')
    headers.set('Authorization', `Bearer ${await createUserJwt(userId)}`)
  }

  headers.set('Content-Type', 'application/json')
  return headers
}

const executeRequest = async ({
  path,
  method,
  data,
  userId,
}: FetchWrapperParams) => {
  const requestData =
    data === undefined ? undefined : convertKeysToSnakeCase(data)
  const res = await fetch(`${getEnv().API_URL}/${path}`, {
    method,
    headers: await buildHeaders(path, userId),
    body: requestData === undefined ? undefined : JSON.stringify(requestData),
  })
  return res
}

interface FetchWrapperParams {
  path: string
  method: string
  data?: unknown
  userId?: string
}

const fetchWrapper = async <R, ErrorKey extends string = string>({
  path,
  method,
  data,
  userId,
}: FetchWrapperParams): Promise<FetchResult<R, ErrorKey>> => {
  const res = await executeRequest({ path, method, data, userId })
  const responseData =
    res.status === 204 ? undefined : convertKeysToCamelCase(await res.json())

  if (!res.ok) {
    return {
      ok: false,
      status: res.status,
      error: responseData as ApiActionError<ErrorKey>,
    }
  }

  return {
    ok: true,
    status: res.status,
    data: responseData as R | undefined,
  }
}

export default fetchWrapper
