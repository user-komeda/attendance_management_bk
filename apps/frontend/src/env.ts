import * as v from 'valibot'

const EnvSchema = v.object({
  API_URL: v.pipe(v.string(), v.nonEmpty(), v.url()),
  SESSION_PASSWORD: v.pipe(v.string(), v.nonEmpty(), v.minLength(32)),
  JWT_SECRET: v.pipe(v.string(), v.nonEmpty(), v.minLength(32)),
  BFF_JWT_SECRET: v.pipe(v.string(), v.nonEmpty(), v.minLength(32)),
  JWT_ISSUER: v.pipe(v.string(), v.nonEmpty()),
  JWT_AUDIENCE: v.pipe(v.string(), v.nonEmpty()),
})

export const getEnv = () => {
  const result = v.safeParse(EnvSchema, process.env)

  if (!result.success) {
    console.error('Invalid frontend env:', result.issues)
    const messages = result.issues.map((issue) => {
      /* v8 ignore next -- @preserve */
      const path = issue.path?.map((item) => item.key).join('.') ?? 'unknown'
      return `${path}: ${issue.message}`
    })

    throw new Error(`Invalid frontend env:\n${messages.join('\n')}`)
  }
  return result.output
}
