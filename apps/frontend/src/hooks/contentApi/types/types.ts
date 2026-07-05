import * as v from 'valibot'

import { CreateContentApiSchema } from '~/schema/contentApi/createContentApiSchhema'
import { ActionResultOf, FieldKeyOf } from '~/types/action'
import { CreateContentApiWithFieldsSchema } from '~/schema/contentApi/createContentApiWithFieldsSchhema'

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
