import * as v from 'valibot'

const SignupSchema = v.pipe(
  v.object({
    firstName: v.pipe(v.string(), v.nonEmpty()),
    lastName: v.pipe(v.string(), v.nonEmpty()),
    email: v.pipe(v.string(), v.nonEmpty(), v.email()),
    password: v.pipe(
      v.string('Your password must be a string.'),
      v.nonEmpty('Please enter your password.'),
      v.minLength(8, 'Your password must have 8 characters or more.'),
    ),
    confirmPassword: v.pipe(
      v.string('Your password must be a string.'),
      v.nonEmpty('Please enter your password.'),
      v.minLength(8, 'Your password must have 8 characters or more.'),
    ),
  }),
  v.forward(
    v.partialCheck(
      [['password'], ['confirmPassword']],
      (input) => input.password === input.confirmPassword,
      'The two passwords do not match.',
    ),
    ['confirmPassword'],
  ),
)
export default SignupSchema
