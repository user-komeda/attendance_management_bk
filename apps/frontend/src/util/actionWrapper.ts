import { action, redirect } from '@solidjs/router'
import * as v from 'valibot'

import { ActionResultOf, FieldKeyOf, FormDataActionOf } from '~/types/action'
import { HttpMethod } from '~/types/fetch'
import bffFetchWrapper from '~/util/bffFetchWrapper'
import { createError } from '~/util/error'

interface HandleFetchParams<S extends v.GenericSchema> {
  path: string
  method: HttpMethod
  output: v.InferOutput<S>
  redirectUrl?: string
}

const handleFetchResult = async <S extends v.GenericSchema>({
  path,
  method,
  output,
  redirectUrl,
}: HandleFetchParams<S>): Promise<ActionResultOf<S>> => {
  const fetchResult = await bffFetchWrapper<unknown, FieldKeyOf<S>>({
    path,
    method,
    data: output,
  })

  if (!fetchResult.ok) {
    return {
      ok: false,
      fieldErrors: fetchResult.error.fieldErrors,
      message: fetchResult.error.message,
    }
  }

  if (redirectUrl) {
    throw redirect(redirectUrl)
  }

  return { ok: true }
}

interface ActionWrapperParams<S extends v.GenericSchema> {
  path: string
  method: HttpMethod
  schema: S
  redirectUrl?: string
  name?: string
}

const actionWrapper = <S extends v.GenericSchema>({
  path,
  method,
  schema,
  redirectUrl,
  name,
}: ActionWrapperParams<S>): FormDataActionOf<S> => {
  return action(async (formData: FormData): Promise<ActionResultOf<S>> => {
    const rawData = Object.fromEntries(formData.entries())
    const result = v.safeParse(schema, rawData)

    if (!result.success) {
      return {
        ok: false,
        fieldErrors: createError<FieldKeyOf<S>>(result.issues),
        message: '',
      }
    }

    return handleFetchResult<S>({
      path,
      method,
      output: result.output,
      redirectUrl,
    })
  }, name)
}
export default actionWrapper
