import { Action, useSubmission } from '@solidjs/router'
import { Show } from 'solid-js'

import { InputPassword } from '~/components/inputPassword'
import { InputText } from '~/components/inputText'
import { findError } from '~/util/error'

export const SigninForm = ({
  action,
}: {
  action: Action<
    [formData: FormData],
    | {
        error: {
          key: string
          message: string
        }[]
      }
    | undefined,
    [formData: FormData]
  >
}) => {
  const submission = useSubmission(action)
  return (
    <div class="flex flex-col justify-center p-4 sm:h-screen">
      <div class="mx-auto w-full max-w-md rounded-2xl border border-gray-300 p-8">
        <form action={action} method="post">
          <div class="space-y-6">
            <div>
              <InputText name="email" label="Email" />
              <Show when={submission.result?.error}>
                <span class="text-sm text-red-500">
                  {findError(submission.result!.error, 'email')}
                </span>
              </Show>
            </div>
            <div>
              <InputPassword name="password" label="Password" />
              <Show when={submission.result?.error}>
                <span class="text-sm text-red-500">
                  {findError(submission.result!.error, 'password')}
                </span>
              </Show>
            </div>
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
