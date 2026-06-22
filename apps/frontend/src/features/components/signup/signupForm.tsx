import { useSubmission } from '@solidjs/router'
import { Accessor, Show } from 'solid-js'

import type { ActionResultOf, FormDataActionOf } from '~/types/action'

import { FormInputText } from '~/components/formInputText'
import { Button } from '~/components/ui/button'
import { CommonCard } from '~/components/ui/commonCard'
import SignupSchema from '~/schema/signupSchema'
import { createObjectSchemaFields } from '~/util/createObjectSchemaFields'
import { findActionMessage } from '~/util/error'

type SignupAction = FormDataActionOf<typeof SignupSchema>
type SignupResult = ActionResultOf<typeof SignupSchema>

// eslint-disable-next-line max-lines-per-function
const Content = (props: { result: Accessor<SignupResult | undefined> }) => {
  const signupField = createObjectSchemaFields(SignupSchema)
  const { result } = props
  return (
    <div class="space-y-6">
      <div>
        <FormInputText
          name={signupField.firstName}
          label={'firstName'}
          result={result()}
        />
      </div>

      <div>
        <FormInputText
          name={signupField.lastName}
          label="lastName"
          result={result()}
        />
      </div>

      <div>
        <FormInputText
          type="email"
          name={signupField.email}
          label="Email"
          result={result()}
        />
      </div>

      <div>
        <FormInputText
          type="password"
          name={signupField.password}
          label="Password"
          result={result()}
        />
      </div>

      <div>
        <FormInputText
          type="password"
          name={signupField.confirmPassword}
          label="Confirm Password"
          result={result()}
        />
      </div>

      <Show when={findActionMessage(result())}>
        {(message) => <p class="text-sm text-red-500">{message()}</p>}
      </Show>
    </div>
  )
}

export const SignupForm = ({ action }: { action: SignupAction }) => {
  const submission = useSubmission(action)
  const formId = 'signup-form'

  return (
    <div class="flex flex-col justify-center p-4 sm:h-screen">
      <div class="mx-auto w-full max-w-md">
        <CommonCard
          title="アカウント作成"
          description="必要な情報を入力してください"
          footer={
            <div class="w-full">
              <Button type="submit" form={formId} disabled={submission.pending}>
                {'Create an account'}
              </Button>

              <p class="mt-6 text-center text-sm text-slate-600">
                Already have an account?{' '}
                <a
                  href="javascript:void(0);"
                  class="ml-1 font-medium text-blue-600 hover:underline"
                >
                  Login here
                </a>
              </p>
            </div>
          }
        >
          <form id={formId} action={action} method="post">
            <Content result={() => submission.result} />
          </form>
        </CommonCard>
      </div>
    </div>
  )
  /* v8 ignore start */
}
/* v8 ignore stop */
