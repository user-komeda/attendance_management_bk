import { action } from '@solidjs/router'
import * as v from 'valibot'

import { ActionResultOf, FormDataActionOf } from '~/types/action'
import { HttpMethod } from '~/types/fetch'
import { handleFetchResult, parseFormData } from '~/util/actionWrapperCommon'

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
    const parsed = parseFormData(schema, formData)

    if (!parsed.success) {
      return parsed.result
    }

    return handleFetchResult<S>({
      path,
      method,
      output: parsed.output,
      redirectUrl,
    })
  }, name)
}

export default actionWrapper
