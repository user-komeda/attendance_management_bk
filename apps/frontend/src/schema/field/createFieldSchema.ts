import * as v from 'valibot'

const formBoolean = v.pipe(
  v.union([v.boolean(), v.picklist(['true', 'false'])]),
  v.transform((value) => {
    if (value === 'true') {
      return true
    }

    if (value === 'false') {
      return false
    }

    return value
  }),
)

export const CreateFieldSchema = v.object({
  fieldId: v.pipe(
    v.string(),
    v.trim(),
    v.minLength(1, 'フィールドIDを入力してください'),
  ),
  displayName: v.pipe(
    v.string(),
    v.trim(),
    v.minLength(1, '表示名を入力してください'),
  ),
  fieldType: v.pipe(
    v.string(),
    v.trim(),
    v.minLength(1, 'フィールドタイプを選択してください'),
  ),
  required: v.optional(formBoolean),
  uniqueValue: v.optional(formBoolean),
  orderIndex: v.optional(v.number()),
  isActive: v.optional(formBoolean),
  settings: v.optional(v.record(v.string(), v.unknown())),
})

export const CreateFieldsSchema = v.pipe(
  v.array(CreateFieldSchema),
  v.minLength(1, 'フィールドを1つ以上追加してください'),
)
