import * as v from 'valibot'
import { ObjectSchema } from 'valibot'

export const findError = (
  errors: { key: string; message: string }[],
  key: string,
) => {
  return errors.find((error) => error.key === key)?.message
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const createError = <S extends ObjectSchema<any, any>>(
  issues: [v.InferIssue<S>, ...v.InferIssue<S>[]],
): { key: string; message: string }[] => {
  return issues.map((issue) => ({
    key: issue.path[0]?.key,
    message: issue.message,
  }))
}
