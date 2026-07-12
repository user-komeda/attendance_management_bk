import { Accessor, Show } from 'solid-js'

import { FormInputText } from '~/components/formInputText'
import { Card, CardContent } from '~/components/ui/card'
import { CreateContentApiResult } from '~/features/components/workspaces/contentApi/createForm'
import { findActionMessage } from '~/util/error'

const InputApiName = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  return (
    <>
      <div class="space-y-2">
        <p class="text-xs text-slate-500">
          APIの内容を入力してください。後から変更できます。
        </p>
      </div>
      <FormInputText name="name" label="API名" result={props.result()} />
    </>
  )
}

const InputApiEndpoint = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  return (
    <>
      <div class="space-y-2">
        <p class="text-xs text-slate-500">
          APIのエンドポイント名を半角で入力してください。後から変更できます。
        </p>
      </div>
      <div class="flex items-center gap-3">
        <span class="shrink-0 text-sm text-slate-700">
          https://z5l8msu8m8.microcms.io/api/v1/
        </span>

        <FormInputText name="endpoint" label="" result={props.result()} />
      </div>
    </>
  )
}

export const BasicInfo = (props: {
  result: Accessor<CreateContentApiResult | undefined>
}) => {
  return (
    <div>
      <h1 class="mb-7 text-center text-2xl font-bold tracking-tight text-slate-950">
        APIの基本情報を入力
      </h1>

      <Card class="mx-auto max-w-[760px] border-none bg-slate-50 shadow-none">
        <CardContent class="space-y-7 p-8">
          <section class="space-y-3">
            <InputApiName result={props.result} />
          </section>

          <section class="space-y-3">
            <InputApiEndpoint result={props.result} />
          </section>
          <Show when={findActionMessage(props.result())}>
            {(message) => <p class="text-sm text-red-500">{message()}</p>}
          </Show>
        </CardContent>
      </Card>
    </div>
  )
}
