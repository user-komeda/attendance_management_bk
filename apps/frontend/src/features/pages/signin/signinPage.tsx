import { SigninForm } from '~/features/components/signin/signinForm'
import { SigninSchema } from '~/schema/signinSchema'
import actionWrapper from '~/util/actionWrapper'

const signin = actionWrapper<typeof SigninSchema>({
  path: '/api/signin',
  method: 'POST',
  schema: SigninSchema,
  redirectUrl: '/',
  name: 'signin',
})
export const SigninPage = () => {
  return <SigninForm action={signin} />
}
// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
/* v8 ignore stop */
