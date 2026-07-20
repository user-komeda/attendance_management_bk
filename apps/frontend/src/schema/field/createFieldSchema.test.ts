import { describe, expect, it } from 'vitest'
import * as v from 'valibot'

import {
  CreateFieldSchema,
  CreateFieldsSchema,
} from '~/schema/field/createFieldSchema'

describe('createFieldSchema', () => {
  it('true/false 文字列を boolean に変換してパースできること', () => {
    const input = {
      fieldId: ' field_id ',
      displayName: ' 表示名 ',
      fieldType: ' text ',
      required: 'true',
      uniqueValue: 'false',
      isActive: true,
    }

    const result = v.parse(CreateFieldSchema, input)

    expect(result).toMatchObject({
      fieldId: 'field_id',
      displayName: '表示名',
      fieldType: 'text',
      required: true,
      uniqueValue: false,
      isActive: true,
    })
  })

  it('必須項目が空文字の場合は失敗すること', () => {
    const result = v.safeParse(CreateFieldSchema, {
      fieldId: ' ',
      displayName: '',
      fieldType: ' ',
    })

    expect(result.success).toBe(false)
  })

  it('CreateFieldsSchema は1件以上の配列を要求すること', () => {
    const emptyResult = v.safeParse(CreateFieldsSchema, [])
    expect(emptyResult.success).toBe(false)

    const filledResult = v.safeParse(CreateFieldsSchema, [
      {
        fieldId: 'id',
        displayName: 'ID',
        fieldType: 'text',
      },
    ])
    expect(filledResult.success).toBe(true)
  })
})
