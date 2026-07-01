import * as v from 'valibot'

export const CreateContentApiSchema = v.object({
  name: v.pipe(v.string(), v.trim(), v.minLength(1, 'API名を入力してください')),
  endpoint: v.pipe(
    v.string(),
    v.trim(),
    v.regex(
      /^[a-z0-9_-]{3,32}$/,
      'エンドポイントは3〜32文字の英小文字・数字・ハイフン・アンダースコアで入力してください',
    ),
  ),
  apiType: v.picklist(['list', 'object'], 'APIの型を選択してください'),
})

export const CreateContentApiBasicSchema = v.pick(CreateContentApiSchema, [
  'name',
  'endpoint',
])

export const CreateContentApiTypeSchema = v.pick(CreateContentApiSchema, [
  'apiType',
])
