import * as v from 'valibot'
import { CreateContentApiSchema } from '~/schema/contentApi/createContentApiSchhema'
import { CreateFieldsSchema } from '~/schema/field/createFieldSchema'

export const CreateContentApiWithFieldsSchema = v.object({
  ...CreateContentApiSchema.entries,
  fields: CreateFieldsSchema,
})
