import { useSubmission } from '@solidjs/router'
import { Show } from 'solid-js'

import type { FormDataActionOf } from '~/types/action'

import { InputText } from '~/components/inputText'
import { SigninSchema } from '~/schema/signinSchema'
import { createObjectSchemaFields } from '~/util/createObjectSchemaFields'
import { findError } from '~/util/error'

type SigninAction = FormDataActionOf<typeof SigninSchema>

export const SigninForm = ({ action }: { action: SigninAction }) => {
  const submission = useSubmission(action)
  const signinField = createObjectSchemaFields(SigninSchema)
  return (
    <div class="flex flex-col justify-center p-4 sm:h-screen">
      <div class="mx-auto w-full max-w-md rounded-2xl border border-gray-300 p-8">
        <form action={action} method="post">
          <div class="space-y-6">
            <div>
              <InputText name={signinField.email} label="Email" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signinField.email,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>
            <div>
              <InputText name={signinField.password} label="Password" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signinField.password,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>

            <Show when={submission.result?.message}>
              {(message) => <p class="text-sm text-red-500">{message()}</p>}
            </Show>
          </div>

          <div class="mt-12">
            <button
              type="submit"
              class="w-full cursor-pointer rounded-md bg-blue-600 px-4 py-3 text-sm font-medium tracking-wider text-white hover:bg-blue-700 focus:outline-none"
            >
              login
            </button>
          </div>
        </form>
      </div>
    </div>
  )
  // 分岐がないはずなのにbranchが50%になるため無視
  /* v8 ignore start */
}
/* v8 ignore stop */
