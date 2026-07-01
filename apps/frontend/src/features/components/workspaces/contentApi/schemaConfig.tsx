import { GripVertical, Plus, Settings, X } from 'lucide-solid'
import { Show } from 'solid-js'

import type { Accessor } from 'solid-js'

import { FormInputText } from '~/components/formInputText'
import { Card, CardContent } from '~/components/ui/card'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '~/components/ui/select'
import { Switch } from '~/components/ui/switch'
import { CreateContentApiResult } from '~/features/components/workspaces/contentApi/createForm'
import { findActionMessage } from '~/util/error'

interface FieldTypeOption {
  value: string
  label: string
}

const fieldTypeOptions: FieldTypeOption[] = [
  { value: 'text', label: 'テキスト' },
  { value: 'textarea', label: 'テキストエリア' },
  { value: 'richEditor', label: 'リッチエディタ' },
  { value: 'image', label: '画像' },
  { value: 'number', label: '数値' },
  { value: 'boolean', label: '真偽値' },
]

const SchemaDescription = () => (
  <div class="mb-10 text-center text-sm leading-7 text-slate-500">
    <p>
      コンテンツID（id）や各種日時（createdAt, updatedAt, publishedAt,
      revisedAt）は自動的に作成されます。
    </p>
    <p>
      ファイルインポートする場合は
      <button
        type="button"
        class="mx-1 text-indigo-500 underline-offset-2 hover:underline"
      >
        こちら
      </button>
      から。
    </p>
  </div>
)

const FieldHeader = () => (
  <div class="mb-4 flex items-center justify-between px-2">
    <span class="text-xs text-indigo-300">Jef_tbzOZx</span>

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
        class="inline-flex items-center gap-1 hover:text-indigo-600"
      >
        <X class="size-4" />
        削除
      </button>
    </div>
  </div>
)

const FieldTypeSelect = () => (
  <div class="space-y-2">
    <label for="fieldType" class="text-base font-bold text-slate-950">
      種類
    </label>

    <Select<FieldTypeOption>
      options={fieldTypeOptions}
      optionValue="value"
      optionTextValue="label"
      placeholder="未選択"
      /* v8 ignore next 3 */
      itemComponent={(props) => (
        <SelectItem item={props.item}>{props.item.rawValue.label}</SelectItem>
      )}
    >
      <SelectTrigger
        id="fieldType"
        class="h-10 border-rose-500 bg-rose-50 text-sm focus:ring-rose-500"
      >
        <SelectValue<FieldTypeOption>>
          {(state) => state.selectedOption()?.label}
        </SelectValue>
      </SelectTrigger>

      <SelectContent />
    </Select>

    <p class="text-xs text-rose-500">選択してください</p>
  </div>
)

const FieldInputs = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => (
  <div class="grid grid-cols-[24px_1fr_1fr_1fr] gap-6 px-2">
    <div class="flex items-center pt-9 text-slate-400">
      <GripVertical class="size-4" />
    </div>

    {/* v8 ignore next */}
    <FormInputText
      label="フィールドID"
      name="fieldId"
      result={props.result()}
      placeHolder="例: title"
    />

    {/* v8 ignore next */}
    <FormInputText
      name="displayName"
      label="表示名"
      placeHolder="例: タイトル"
      result={props.result()}
    />

    <FieldTypeSelect />
  </div>
)

const FieldConfig = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => (
  <div class="border-y border-slate-200 px-2 py-3">
    <FieldHeader />
    {/* v8 ignore next */}
    <FieldInputs result={props.result} />

    <div class="mt-5 flex items-center justify-end gap-2 px-2 text-sm text-slate-700">
      <span>必須項目</span>
      <Switch />
    </div>
  </div>
)

export const SchemaConfig = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  return (
    <section>
      <h2 class="mb-10 text-center text-2xl font-bold tracking-tight text-slate-950">
        APIスキーマを定義
      </h2>

      <SchemaDescription />

      <Card class="border-none shadow-none">
        <CardContent class="p-0">
          {/* v8 ignore next */}
          <FieldConfig result={props.result} />

          <button
            type="button"
            class="mt-10 flex h-12 w-full items-center justify-center gap-2 rounded border border-indigo-600 text-sm font-bold text-indigo-600 hover:bg-indigo-50"
          >
            <Plus class="size-4" />
            フィールドを追加
          </button>

          <Show when={findActionMessage(props.result())}>
            {(message) => <p class="mt-4 text-sm text-red-500">{message()}</p>}
          </Show>
        </CardContent>
      </Card>
    </section>
  )
}
