import { useSubmission } from '@solidjs/router'
import { Show } from 'solid-js'

import type { FormDataActionOf } from '~/types/action'

import { InputPassword } from '~/components/inputPassword'
import { InputText } from '~/components/inputText'
import SignupSchema from '~/schema/signupSchema'
import { createObjectSchemaFields } from '~/util/createObjectSchemaFields'
import { findError } from '~/util/error'

type SignupAction = FormDataActionOf<typeof SignupSchema>

export const SignupForm = ({ action }: { action: SignupAction }) => {
  const submission = useSubmission(action)
  const signupField = createObjectSchemaFields(SignupSchema)
  return (
    <div class="flex flex-col justify-center p-4 sm:h-screen">
      <div class="mx-auto w-full max-w-md rounded-2xl border border-gray-300 p-8">
        <form action={action} method="post">
          <div class="space-y-6">
            <div>
              <InputText name={signupField.firstName} label="firstName" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signupField.firstName,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>

            <div>
              <InputText name={signupField.lastName} label="lastName" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signupField.lastName,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>

            <div>
              <InputText name={signupField.email} label="Email" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signupField.email,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>

            <div>
              <InputPassword name={signupField.password} label="Password" />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signupField.password,
                )}
              >
                {(message) => (
                  <span class="text-sm text-red-500">{message()}</span>
                )}
              </Show>
            </div>

            <div>
              <InputPassword
                name={signupField.confirmPassword}
                label="Confirm Password"
              />
              <Show
                when={findError(
                  submission.result?.fieldErrors,
                  signupField.confirmPassword,
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
  /* v8 ignore start */
}
/* v8 ignore stop */
