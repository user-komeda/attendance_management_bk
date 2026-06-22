import { useSubmission } from '@solidjs/router'
import { Accessor, Show } from 'solid-js'

import type { ActionResultOf, FormDataActionOf } from '~/types/action'

import { FormInputText } from '~/components/formInputText'
import { Button } from '~/components/ui/button'
import { CommonCard } from '~/components/ui/commonCard'
import { SigninSchema } from '~/schema/signinSchema'
import { createObjectSchemaFields } from '~/util/createObjectSchemaFields'
import { findActionMessage } from '~/util/error'

type SigninAction = FormDataActionOf<typeof SigninSchema>
type SigninResult = ActionResultOf<typeof SigninSchema>

const Content = (props: { result: Accessor<SigninResult | undefined> }) => {
  const { result } = props
  const signinField = createObjectSchemaFields(SigninSchema)

  return (
    <div class="space-y-6">
      <div>
        <FormInputText
          type="email"
          result={result()}
          name={signinField.email}
          label="Email"
        />
      </div>

      <div>
        <FormInputText
          type="password"
          result={result()}
          name={signinField.password}
          label="Password"
        />
      </div>

      <Show when={findActionMessage(result())}>
        {(message) => <p class="text-sm text-red-500">{message()}</p>}
      </Show>
    </div>
  )
}

export const SigninForm = ({ action }: { action: SigninAction }) => {
  const submission = useSubmission(action)
  const formId = 'signin-form'

  return (
    <div class="flex flex-col justify-center p-4 sm:h-screen">
      <div class="mx-auto w-full max-w-md">
        <CommonCard
          title="ログイン"
          description="アカウントにログインします"
          footer={
            <Button type="submit" form={formId} disabled={submission.pending}>
              {'Login'}
            </Button>
          }
        >
          <form id={formId} action={action} method="post">
            <Content result={() => submission.result} />
          </form>
        </CommonCard>
      </div>
    </div>
  )
  // 分岐がないはずなのにbranchが50%になるため無視
  /* v8 ignore start */
}
/* v8 ignore stop */
