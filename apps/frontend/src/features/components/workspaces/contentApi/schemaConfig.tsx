import { Plus } from 'lucide-solid'
import { For, Show } from 'solid-js'

import type { Accessor } from 'solid-js'
import type { CreateContentApiResult } from '~/features/components/workspaces/contentApi/createForm'

import { Card, CardContent } from '~/components/ui/card'
import { Switch, SwitchControl, SwitchThumb } from '~/components/ui/switch'
import {
  FieldHeader,
  FieldInputs,
} from '~/features/components/workspaces/contentApi/schemaConfigParts'
import { useFieldArray } from '~/hooks/useFieldArray'
import { findActionMessage } from '~/util/error'

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

const FieldConfig = (props: {
  fieldKey: string
  index: number
  canRemove: Accessor<boolean>
  onRemove: () => void
  result: Accessor<CreateContentApiResult | undefined>
}) => (
  <div class="border-y border-slate-200 px-2 py-3">
    <FieldHeader
      fieldKey={props.fieldKey}
      canRemove={props.canRemove}
      onRemove={props.onRemove}
    />

    {/* v8 ignore next */}
    <FieldInputs index={props.index} result={props.result} />

    <div class="mt-5 flex items-center justify-end gap-2 px-2 text-sm text-slate-700">
      <span>必須項目</span>
      <input
        type="hidden"
        name={`fields[${props.index}][required]`}
        value="false"
      />
      <Switch name={`fields[${props.index}][required]`} value="true">
        <SwitchControl>
          <SwitchThumb />
        </SwitchControl>
      </Switch>
    </div>
  </div>
)

// eslint-disable-next-line max-lines-per-function
export const SchemaConfig = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  const fieldArray = useFieldArray()
  const canRemove = () => fieldArray.fields().length > 1

  return (
    <section>
      <h2 class="mb-10 text-center text-2xl font-bold tracking-tight text-slate-950">
        APIスキーマを定義
      </h2>

      <SchemaDescription />

      <Card class="border-none shadow-none">
        <CardContent class="p-0">
          <For each={fieldArray.fields()}>
            {(field, index) => (
              <FieldConfig
                fieldKey={field.key}
                index={index()}
                canRemove={canRemove}
                onRemove={() => fieldArray.remove(field.key)}
                result={props.result}
              />
            )}
          </For>

          <button
            type="button"
            class="mt-10 flex h-12 w-full items-center justify-center gap-2 rounded border border-indigo-600 text-sm font-bold text-indigo-600 hover:bg-indigo-50"
            onClick={fieldArray.append}
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
