import * as v from 'valibot'

const EnvSchema = v.object({
  VITE_API_URL: v.pipe(v.string(), v.nonEmpty(), v.url()),
})

export const getEnv = () => {
  const result = v.safeParse(EnvSchema, process.env)
  // console.log('result', process.env)
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
