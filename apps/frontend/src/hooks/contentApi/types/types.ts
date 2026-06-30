import * as v from 'valibot'

import { CreateContentApiSchema } from '~/schema/contentApi/createContentApiSchhema'
import { ActionResultOf, FieldKeyOf } from '~/types/action'

export type CreateContentApiStep = 'basic' | 'type' | 'schema'
export type CreateContentApiResult = ActionResultOf<
  typeof CreateContentApiSchema
>
export type CreateContentApiFieldKey = FieldKeyOf<typeof CreateContentApiSchema>
export interface StepConfig {
  schema: v.GenericSchema
  keys: Partial<Record<CreateContentApiFieldKey, true>>
}
