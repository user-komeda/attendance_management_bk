import { SignupForm } from '~/features/components/signup/signupForm'
import SignupSchema from '~/schema/signupSchema'
import actionWrapper from '~/util/actionWrapper'

const signup = actionWrapper<typeof SignupSchema, undefined>(
  '/api/signup',
  'login',
  SignupSchema,
  '/',
)

export const SignupPage = () => {
  return <SignupForm action={signup} />
// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
}
/* v8 ignore stop */
