import * as v from 'valibot'

import { FieldKeyOf } from '~/types/action'

export const createObjectSchemaFields = <
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  Schema extends v.ObjectSchema<any, any>,
>(
  schema: Schema,
) => {
  return Object.fromEntries(
    Object.keys(schema.entries).map((key) => [key, key]),
  ) as {
    [Key in FieldKeyOf<Schema>]: Key
  }
}
