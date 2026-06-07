import * as v from 'valibot'

export const findError = <Key extends string>(
  errors: readonly { key: Key; message: string }[] | undefined,
  key: Key,
) => {
  return errors?.find((error) => error.key === key)?.message
}

export const createError = <Key extends string>(
  issues: readonly v.BaseIssue<unknown>[],
): { key: Key; message: string }[] => {
  return issues.flatMap((issue) => {
    const key = issue.path?.[0]?.key

    if (typeof key !== 'string') {
      return []
    }

    return [
      {
        key: key as Key,
        message: issue.message,
      },
    ]
  })
}
