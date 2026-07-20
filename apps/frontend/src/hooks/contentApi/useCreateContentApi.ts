import { useSubmission } from '@solidjs/router'
import { createEffect } from 'solid-js'

import type { FormDataActionOf } from '~/types/action'

import { CreateContentApiResult } from '~/hooks/contentApi/types/types'
import { useCreateContentApiStep } from '~/hooks/contentApi/useCreateContentApiStep'
import { CreateContentApiWithFieldsSchema } from '~/schema/contentApi/createContentApiWithFieldsSchhema'

type CreateContentApiAction = FormDataActionOf<
  typeof CreateContentApiWithFieldsSchema
>

export const useCreateContentApi = (props: {
  action: CreateContentApiAction
}) => {
  const submission = useSubmission(props.action)
  const { step, stepResult, handleNext, handleBack, moveToErrorStep } =
    useCreateContentApiStep()

  createEffect(() => {
    moveToErrorStep(submission.result)
  })

  const result = (): CreateContentApiResult | undefined =>
    stepResult() ?? submission.result

  return {
    step,
    submission,
    result,
    handleNext,
    handleBack,
  }
}
