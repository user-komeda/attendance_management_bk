import { action } from '@solidjs/router'
import * as v from 'valibot'

import { ActionResultOf, FormDataActionWithParamOf } from '~/types/action'
import { HttpMethod } from '~/types/fetch'
import { handleFetchResult, parseFormData } from '~/util/actionWrapperCommon'

interface ActionWrapperWithParamParams<S extends v.GenericSchema, Param> {
  path: (param: Param) => string
  method: HttpMethod
  schema: S
  redirectUrl?: string
  name?: string
}

const actionWrapperWithParam = <S extends v.GenericSchema, Param>({
  path,
  method,
  schema,
  redirectUrl,
  name,
}: ActionWrapperWithParamParams<S, Param>): FormDataActionWithParamOf<
  S,
  Param
> => {
  return action(
    async (param: Param, formData: FormData): Promise<ActionResultOf<S>> => {
      const parsed = parseFormData(schema, formData)

      if (!parsed.success) {
        return parsed.result
      }

      return handleFetchResult<S>({
        path: path(param),
        method,
        output: parsed.output,
        redirectUrl,
      })
    },
    name,
  )
}
export default actionWrapperWithParam
