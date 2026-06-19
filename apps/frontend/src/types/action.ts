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
