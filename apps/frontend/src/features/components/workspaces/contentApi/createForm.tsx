import type { ActionResultOf, FormDataActionOf } from '~/types/action'

import { Button } from '~/components/ui/button'
import { Flex } from '~/components/ui/flex'
import { BasicInfo } from '~/features/components/workspaces/contentApi/basicInfo'
import { SchemaConfig } from '~/features/components/workspaces/contentApi/schemaConfig'
import { TypeSelect } from '~/features/components/workspaces/contentApi/typeSelect'
import { useCreateContentApi } from '~/hooks/contentApi/useCreateContentApi'
import { CreateContentApiSchema } from '~/schema/contentApi/createContentApiSchhema'

export type ApiType = 'list' | 'object'
type CreateContentApiAction = FormDataActionOf<typeof CreateContentApiSchema>
export type CreateContentApiResult = ActionResultOf<
  typeof CreateContentApiSchema
>

// eslint-disable-next-line max-lines-per-function
export const CreateForm = (props: { action: CreateContentApiAction }) => {
  const { step, submission, result, handleNext, handleBack } =
    useCreateContentApi({
      action: props.action,
    })

  return (
    <form
      action={props.action}
      method="post"
      class="min-h-screen bg-white px-8 py-8"
    >
      <section classList={{ hidden: step() !== 'basic' }}>
        <BasicInfo result={result} />

        <Flex justifyContent="end" class="mx-auto mt-8 max-w-[760px]">
          <Button
            type="button"
            onClick={(event) => handleNext('basic', 'type', event)}
            class="h-10"
          >
            次へ
          </Button>
        </Flex>
      </section>

      <section classList={{ hidden: step() !== 'type' }}>
        <TypeSelect result={result} />

        <Flex class="mx-auto mt-8 max-w-[680px]">
          <Button
            type="button"
            onClick={() => handleBack('basic')}
            class="h-10"
          >
            戻る
          </Button>

          <Button
            type="button"
            onClick={(event) => handleNext('type', 'schema', event)}
            class="h-10"
          >
            次へ
          </Button>
        </Flex>
      </section>

      <section classList={{ hidden: step() !== 'schema' }}>
        <SchemaConfig result={result} />

        <Flex class="mx-auto mt-8 max-w-[760px]">
          <Button type="button" onClick={() => handleBack('type')} class="h-10">
            戻る
          </Button>

          <Button type="submit" disabled={submission.pending} class="h-10">
            {submission.pending ? '作成中...' : '作成'}
          </Button>
        </Flex>
      </section>
    </form>
  )
}
