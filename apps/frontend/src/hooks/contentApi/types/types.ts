import * as v from 'valibot'

import { CreateContentApiWithFieldsSchema } from '~/schema/contentApi/createContentApiWithFieldsSchhema'
import { ActionResultOf, FieldKeyOf } from '~/types/action'

export type CreateContentApiStep = 'basic' | 'type' | 'schema'
export type CreateContentApiResult = ActionResultOf<
  typeof CreateContentApiWithFieldsSchema
>
export type CreateContentApiFieldKey = FieldKeyOf<
  typeof CreateContentApiWithFieldsSchema
>
export interface StepConfig {
  schema: v.GenericSchema
  keys: Partial<Record<CreateContentApiFieldKey, true>>
}
