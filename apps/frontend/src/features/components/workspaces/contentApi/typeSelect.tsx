import { For, Show } from 'solid-js'

import type { Accessor } from 'solid-js'

import { Flex } from '~/components/ui/flex'
import {
  RadioGroup,
  RadioGroupItem,
  RadioGroupItemLabel,
} from '~/components/ui/radio-group'
import {
  ApiType,
  CreateContentApiResult,
} from '~/features/components/workspaces/contentApi/createForm'
import { findActionMessage, findError } from '~/util/error'

const apiTypes = [
  {
    value: 'list',
    title: 'リスト形式',
    description:
      'JSON配列を返却するAPIを作成します。ブログやお知らせの一覧、カルーセル等に適しています。',
  },
  {
    value: 'object',
    title: 'オブジェクト形式',
    description:
      'JSONオブジェクトを返却するAPIを作成します。設定ファイルや単体ページ情報などの取得に適しています。',
  },
] as const satisfies {
  value: ApiType
  title: string
  description: string
}[]

export const TypeSelect = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  const errorMessage = () =>
    findError(props.result(), 'apiType') ?? findActionMessage(props.result())

  return (
    <section>
      <h2 class="mb-8 text-center text-2xl font-bold tracking-tight text-slate-950">
        APIの型を選択
      </h2>

      <RadioGroup
        name="apiType"
        defaultValue="list"
        class="mx-auto grid max-w-[680px] grid-cols-2 gap-20"
      >
        <For each={apiTypes}>
          {(item) => (
            <RadioGroupItem
              value={item.value}
              class="h-[250px] rounded border border-slate-200 text-left transition-colors hover:bg-slate-50 data-[checked]:border-indigo-600"
            >
              <RadioGroupItemLabel class="h-full w-full cursor-pointer p-6">
                <Flex
                  flexDirection="col"
                  justifyContent="center"
                  alignItems="center"
                  class="h-full"
                >
                  <h3 class="mb-6 text-center text-base font-bold text-slate-950">
                    {item.title}
                  </h3>

                  <p class="w-full text-sm leading-6 text-slate-500">
                    {item.description}
                  </p>
                </Flex>
              </RadioGroupItemLabel>
            </RadioGroupItem>
          )}
        </For>
      </RadioGroup>

      <Show when={errorMessage()}>
        {(message) => (
          <p class="mx-auto mt-4 max-w-[680px] text-sm text-red-500">
            {message()}
          </p>
        )}
      </Show>
    </section>
  )
}
