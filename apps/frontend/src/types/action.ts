import * as v from 'valibot'

import type { Action } from '@solidjs/router'

import { HttpMethod } from '~/types/fetch'

export type FieldKeyOf<Schema extends v.GenericSchema> = Extract<
  keyof v.InferInput<Schema>,
  string
>

export interface FieldErrorPathItem {
  key: string | number
}

export type FieldErrorPath = FieldErrorPathItem[]

interface ActionFieldError<Key extends string = string> {
  key: Key
  path?: FieldErrorPath
  message: string
}

export type ActionResult<Key extends string = string> =
  | {
      ok: true
    }
  | {
      ok: false
      fieldErrors: ActionFieldError<Key>[]
      message: string
    }

export type ActionResultOf<Schema extends v.GenericSchema> = ActionResult<
  FieldKeyOf<Schema>
>

export type FormDataActionOf<Schema extends v.GenericSchema> = Action<
  [formData: FormData],
  ActionResultOf<Schema>,
  [formData: FormData]
>

export type FormDataActionWithParamOf<
  Schema extends v.GenericSchema,
  Param,
> = Action<
  [param: Param, formData: FormData],
  ActionResultOf<Schema>,
  [formData: FormData]
>

export type ParseFormDataResult<S extends v.GenericSchema> =
  | {
      success: true
      output: v.InferOutput<S>
    }
  | {
      success: false
      result: ActionResultOf<S>
    }
export interface HandleFetchParams<S extends v.GenericSchema> {
  path: string
  method: HttpMethod
  output: v.InferOutput<S>
  redirectUrl?: string
}
