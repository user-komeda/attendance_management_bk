import * as v from 'valibot'

import type { ActionResult, FieldErrorPath } from '~/types/action'

const parseFormNamePath = (name: string): FieldErrorPath => {
  return [...name.matchAll(/[^[\]]+/g)].map((match) => {
    const value = match[0]
    const numberValue = Number(value)

    return {
      key:
        Number.isInteger(numberValue) && value === String(numberValue)
          ? numberValue
          : value,
    }
  })
}

const issuePathToFieldErrorPath = (
  path: v.BaseIssue<unknown>['path'] | undefined,
): FieldErrorPath => {
  return (path ?? []).flatMap((item) => {
    if (typeof item.key !== 'string' && typeof item.key !== 'number') {
      return []
    }

    return [{ key: item.key }]
  })
}

const isSamePath = (a: FieldErrorPath, b: FieldErrorPath) => {
  /* v8 ignore next */
  if (a.length !== b.length) {
    return false
  }

  return a.every((item, index) => item.key === b[index]?.key)
}

export const findError = <Key extends string>(
  result: ActionResult<Key> | undefined,
  name: string,
) => {
  if (result?.ok !== false) {
    return undefined
  }

  const path = parseFormNamePath(name)
  const rootKey = path[0]?.key

  if (typeof rootKey !== 'string') {
    return undefined
  }

  return result.fieldErrors?.find((error) => {
    if (error.key !== rootKey) {
      return false
    }

    if (error.path !== undefined) {
      return isSamePath(error.path, path)
    }

    return name === error.key
  })?.message
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
): { key: Key; path?: FieldErrorPath; message: string }[] => {
  return issues.flatMap((issue) => {
    const key = issue.path?.[0]?.key

    if (typeof key !== 'string') {
      return []
    }

    return [
      {
        key: key as Key,
        path: issuePathToFieldErrorPath(issue.path),
        message: issue.message,
      },
    ]
  })
}
