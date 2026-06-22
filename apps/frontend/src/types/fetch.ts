export interface ApiActionError<Key extends string = string> {
  message: string
  fieldErrors: {
    key: Key
    message: string
  }[]
}

export type FetchResult<R, ErrorKey extends string = string> =
  | {
      ok: true
      status: number
      data: R | undefined
    }
  | {
      ok: false
      status: number
      error: ApiActionError<ErrorKey>
    }

export type HttpMethod = 'GET' | 'POST' | 'DELETE' | 'PATCH' | 'PUT'

export interface FetchParams {
  method: HttpMethod
  path: string
}
