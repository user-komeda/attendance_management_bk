import { redirect } from '@solidjs/router'
import * as v from 'valibot'

import {
  ActionResultOf,
  FieldKeyOf,
  HandleFetchParams,
  ParseFormDataResult,
} from '~/types/action'
import bffFetchWrapper from '~/util/bffFetchWrapper'
import { createError } from '~/util/error'
import { formDataToObject } from '~/util/formDataToObject'

export const handleFetchResult = async <S extends v.GenericSchema>({
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

export const parseFormData = <S extends v.GenericSchema>(
  schema: S,
  formData: FormData,
): ParseFormDataResult<S> => {
  const rawData = formDataToObject(formData)
  const result = v.safeParse(schema, rawData)
  if (!result.success) {
    return {
      success: false,
      result: {
        ok: false,
        fieldErrors: createError<FieldKeyOf<S>>(result.issues),
        message: '',
      },
    }
  }

  return {
    success: true,
    output: result.output,
  }
}
