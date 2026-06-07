import * as v from 'valibot'

import type { Action } from '@solidjs/router'

export type FieldKeyOf<Schema extends v.GenericSchema> = Extract<
  keyof v.InferInput<Schema>,
  string
>

interface ActionFieldError<Key extends string = string> {
  key: Key
  message: string
}

type ActionResult<Key extends string = string> =
  | {
      fieldErrors: ActionFieldError<Key>[]
      message: string
    }
  | undefined

export type ActionResultOf<Schema extends v.GenericSchema> = ActionResult<
  FieldKeyOf<Schema>
>

export type FormDataActionOf<Schema extends v.GenericSchema> = Action<
  [formData: FormData],
  ActionResultOf<Schema>,
  [formData: FormData]
>
