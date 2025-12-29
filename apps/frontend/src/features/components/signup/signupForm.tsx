 

import { Action, useSubmission } from '@solidjs/router'
import { Show } from 'solid-js'

import { InputPassword } from '~/components/inputPassword'
import { InputText } from '~/components/inputText'
import { findError } from '~/util/error'

export const SignupForm = ({
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
              <InputText name="firstName" label="firstName" />
              <Show when={submission.result?.error}>
                <span class="text-sm text-red-500">
                  {findError(submission.result!.error, 'firstName')}
                </span>
              </Show>
            </div>
            <div>
              <InputText name="lastName" label="lastName" />
              <Show when={submission.result?.error}>
                <span class="text-sm text-red-500">
                  {findError(submission.result!.error, 'lastName')}
                </span>
              </Show>
            </div>
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
            <div>
              <InputPassword name="confirmPassword" label="Confirm Password" />
              <Show when={submission.result?.error}>
                <span class="text-sm text-red-500">
                  {findError(submission.result!.error, 'confirmPassword')}
                </span>
              </Show>
            </div>
            {/*<InputCheckBox/>*/}
          </div>

          <div class="mt-12">
            <button
              type="submit"
              class="w-full cursor-pointer rounded-md bg-blue-600 px-4 py-3 text-sm font-medium tracking-wider text-white hover:bg-blue-700 focus:outline-none"
            >
              Create an account
            </button>
          </div>
          <p class="mt-6 text-center text-sm text-slate-600">
            Already have an account?{' '}
            <a
              href="javascript:void(0);"
              class="ml-1 font-medium text-blue-600 hover:underline"
            >
              Login here
            </a>
          </p>
        </form>
      </div>
    </div>
  )
// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
}
/* v8 ignore stop */
