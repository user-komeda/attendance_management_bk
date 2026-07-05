import { createSignal, Setter } from 'solid-js'
import * as v from 'valibot'

import {
  CreateContentApiFieldKey,
  CreateContentApiResult,
  CreateContentApiStep,
  StepConfig,
} from '~/hooks/contentApi/types/types'
import {
  CreateContentApiBasicSchema,
  CreateContentApiTypeSchema,
} from '~/schema/contentApi/createContentApiSchhema'
import { CreateFieldsSchema } from '~/schema/field/createFieldSchema'
import { createError } from '~/util/error'
import { formDataToObject } from '~/util/formDataToObject'

const stepConfigs = {
  basic: {
    schema: CreateContentApiBasicSchema,
    keys: { name: true, endpoint: true },
  },
  type: {
    schema: CreateContentApiTypeSchema,
    keys: { apiType: true },
  },
  schema: {
    schema: CreateFieldsSchema,
    keys: {},
  },
} as const satisfies Record<CreateContentApiStep, StepConfig>

const stepEntries = Object.entries(stepConfigs) as [
  CreateContentApiStep,
  StepConfig,
][]

const getFormValues = (form: HTMLFormElement) => {
  return formDataToObject(new FormData(form))
}

const firstErrorStep = (
  result: CreateContentApiResult | undefined,
): CreateContentApiStep | undefined => {
  const key = result?.ok === false ? result.fieldErrors[0]?.key : undefined

  if (key === undefined) {
    return undefined
  }

  return stepEntries.find(([, config]) => key in config.keys)?.[0] ?? 'schema'
}

const validateStep = (
  currentStep: CreateContentApiStep,
  form: HTMLFormElement,
  setStepResult: Setter<CreateContentApiResult | undefined>,
) => {
  const result = v.safeParse(
    stepConfigs[currentStep].schema,
    getFormValues(form),
  )

  if (result.success) {
    setStepResult(undefined)
    return true
  }

  console.log(result.issues)

  setStepResult({
    ok: false,
    fieldErrors: createError<CreateContentApiFieldKey>(result.issues),
    message: '',
  })

  return false
}

export const useCreateContentApiStep = () => {
  const [step, setStep] = createSignal<CreateContentApiStep>('basic')
  const [stepResult, setStepResult] = createSignal<CreateContentApiResult>()

  const handleNext = (
    currentStep: CreateContentApiStep,
    nextStep: CreateContentApiStep,
    event: MouseEvent & { currentTarget: HTMLButtonElement },
  ) => {
    const form = event.currentTarget.form

    if (form === null || !validateStep(currentStep, form, setStepResult)) {
      return
    }

    setStep(nextStep)
  }

  const handleBack = (prevStep: CreateContentApiStep) => {
    setStepResult(undefined)
    setStep(prevStep)
  }

  const moveToErrorStep = (result: CreateContentApiResult | undefined) => {
    const errorStep = firstErrorStep(result)

    if (errorStep === undefined) {
      return
    }

    setStepResult(undefined)
    setStep(errorStep)
  }

  return { step, stepResult, handleNext, handleBack, moveToErrorStep }
}
