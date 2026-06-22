import { Show } from 'solid-js'

import {
  TextField,
  TextFieldErrorMessage,
  TextFieldInput,
  TextFieldLabel,
} from '~/components/ui/text-field'
import { ActionResult } from '~/types/action'
import { findError } from '~/util/error'

export const FormInputText = <Key extends string>(props: {
  name: string
  label: string
  result: ActionResult<Key> | undefined
  placeHolder?: string
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url'
}) => {
  const errorMessage = () => findError(props.result, props.name)

  return (
    <>
      <TextField validationState={errorMessage() ? 'invalid' : 'valid'}>
        <TextFieldLabel for={props.name}>{props.label}</TextFieldLabel>
        <TextFieldInput
          type={props.type ?? 'text'}
          name={props.name}
          placeholder={props.placeHolder}
        />

        <Show when={errorMessage()}>
          {(message) => (
            <TextFieldErrorMessage>{message()}</TextFieldErrorMessage>
          )}
        </Show>
      </TextField>
    </>
  )
  // 分岐がないはずなのにbranchが50%になるため無視
  /* v8 ignore start */
}
/* v8 ignore stop */
