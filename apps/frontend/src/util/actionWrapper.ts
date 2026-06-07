import { action, redirect } from '@solidjs/router'
import * as v from 'valibot'

import { ActionResultOf, FieldKeyOf, FormDataActionOf } from '~/types/action'
import bffFetchWrapper from '~/util/bffFetchWrapper'
import { createError } from '~/util/error'

const actionWrapper = <S extends v.GenericSchema>(
  url: string,
  name: string,
  schema: S,
  redirectUrl?: string,
): FormDataActionOf<S> => {
  return action(async (formData: FormData): Promise<ActionResultOf<S>> => {
    const rawData = Object.fromEntries(formData.entries())
    const result = v.safeParse(schema, rawData)

    if (!result.success) {
      return {
        fieldErrors: createError<FieldKeyOf<S>>(result.issues),
        message: '',
      }
    }
    const fetchResult = await bffFetchWrapper<unknown, FieldKeyOf<S>>(
      url,
      'POST',
      result.output,
    )
    if (!fetchResult.ok) {
      return fetchResult.error
    }

    if (redirectUrl) {
      throw redirect(redirectUrl)
    }

    return undefined
  }, name)
}
export default actionWrapper
