import { GripVertical, Settings, X } from 'lucide-solid'
import { Accessor } from 'solid-js'

import type { CreateContentApiResult } from '~/features/components/workspaces/contentApi/createForm'

import { FormInputText } from '~/components/formInputText'
import { FieldTypeSelect } from '~/features/components/workspaces/contentApi/schemaConfigSelectParts'

export interface FieldTypeOption {
  value: string
  label: string
}

export const fieldTypeOptions: FieldTypeOption[] = [
  { value: 'text', label: 'テキスト' },
  { value: 'textarea', label: 'テキストエリア' },
  { value: 'richEditor', label: 'リッチエディタ' },
  { value: 'image', label: '画像' },
  { value: 'number', label: '数値' },
  { value: 'boolean', label: '真偽値' },
]

export const FieldHeader = (props: {
  fieldKey: string
  canRemove: Accessor<boolean>
  onRemove: () => void
}) => (
  <div class="mb-4 flex items-center justify-between px-2">
    <span class="text-xs text-indigo-300">{props.fieldKey}</span>

    <div class="flex items-center gap-5 text-sm text-indigo-400">
      <button
        type="button"
        class="inline-flex items-center gap-1 hover:text-indigo-600"
      >
        <Settings class="size-4" />
        詳細設定
      </button>

      <button
        type="button"
        class="inline-flex items-center gap-1 hover:text-indigo-600 disabled:cursor-not-allowed disabled:opacity-40"
        disabled={!props.canRemove()}
        onClick={props.onRemove}
      >
        <X class="size-4" />
        削除
      </button>
    </div>
  </div>
)

export const FieldInputs = (props: {
  index: number
  result: Accessor<CreateContentApiResult | undefined>
}) => (
  <div class="grid grid-cols-[24px_1fr_1fr_1fr] gap-6 px-2">
    <div class="flex items-center pt-9 text-slate-400">
      <GripVertical class="size-4" />
    </div>

    <FormInputText
      label="フィールドID"
      name={`fields[${props.index}][fieldId]`}
      result={props.result()}
      placeHolder="例: title"
    />

    <FormInputText
      name={`fields[${props.index}][displayName]`}
      label="表示名"
      placeHolder="例: タイトル"
      result={props.result()}
    />

    <FieldTypeSelect
      id={`fields-${props.index}-fieldType`}
      name={`fields[${props.index}][fieldType]`}
      result={props.result()}
    />
  </div>
)
