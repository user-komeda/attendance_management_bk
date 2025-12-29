import { action, redirect } from '@solidjs/router'
import * as v from 'valibot'
import { ObjectSchema } from 'valibot'

import { createError } from '~/util/error'
import postWrapper from '~/util/postWrapper'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const actionWrapper = <S extends ObjectSchema<any, any>, R>(
  url: string,
  name: string,
  schema: S,
  redirectUrl?: string,
) => {
  return action(async (formData: FormData) => {
    const rawData = Object.fromEntries(formData.entries())
    const result = v.safeParse(schema, rawData)
    if (!result.success) {
      const errors = createError(result.issues)
      return { error: errors }
    }
    const body = await postWrapper<R>(url, result.output)
    if (redirectUrl) {
      throw redirect('/')
    }
    return body
  }, name)
}

export default actionWrapper
