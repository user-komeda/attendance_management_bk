import { Show } from 'solid-js'

import {
  Select,
  SelectContent,
  SelectHiddenSelect,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '~/components/ui/select'
import {
  FieldTypeOption,
  fieldTypeOptions,
} from '~/features/components/workspaces/contentApi/schemaConfigParts'
import { CreateContentApiResult } from '~/hooks/contentApi/types/types'
import { findError } from '~/util/error'

// eslint-disable-next-line max-lines-per-function
export const FieldTypeSelect = (props: {
  id: string
  name: string
  result: CreateContentApiResult | undefined
}) => {
  return (
    <div class="space-y-2">
      <label for={props.id} class="text-base font-bold text-slate-950">
        種類
      </label>

      <Select<FieldTypeOption>
        name={props.name}
        options={fieldTypeOptions}
        optionValue="value"
        optionTextValue="label"
        placeholder="未選択"
        /* v8 ignore start */
        itemComponent={(itemProps) => (
          <SelectItem item={itemProps.item}>
            {itemProps.item.rawValue.label}
          </SelectItem>
        )}
        /* v8 ignore stop */
      >
        <SelectHiddenSelect />

        <SelectTrigger
          id={props.id}
          class="h-10 border-rose-500 bg-rose-50 text-sm focus:ring-rose-500"
        >
          <SelectValue<FieldTypeOption>>
            {(state) => state.selectedOption()?.label}
          </SelectValue>
        </SelectTrigger>

        <SelectContent />
      </Select>

      <Show when={findError(props.result, props.name)}>
        {(message) => <p class="text-xs text-rose-500">{message()}</p>}
      </Show>
    </div>
  )
}
