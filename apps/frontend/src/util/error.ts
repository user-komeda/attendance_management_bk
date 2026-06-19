import * as v from 'valibot'

import type { ActionResult } from '~/types/action'

export const findError = <Key extends string>(
  result: ActionResult<Key> | undefined,
  key: Key,
) => {
  if (result?.ok !== false) {
    return undefined
  }

  return result.fieldErrors?.find((error) => error.key === key)?.message
}

export const findActionMessage = <Key extends string>(
  result: ActionResult<Key> | undefined,
) => {
  if (result?.ok !== false) {
    return undefined
  }

  return result.message || undefined
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
