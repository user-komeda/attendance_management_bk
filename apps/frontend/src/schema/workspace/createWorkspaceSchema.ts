import * as v from 'valibot'

export const CreateWorkspaceSchema = v.object({
  name: v.pipe(
    v.string(),
    v.trim(),
    v.minLength(1, 'ワークスペース名を入力してください'),
  ),
  slug: v.pipe(
    v.string(),
    v.trim(),
    v.regex(
      /^(?!-)(?!.*--)[a-z0-9-]{3,32}(?<!-)$/,
      'サービスIDは3〜32文字の英小文字・数字・ハイフンで入力してください',
    ),
  ),
})
