import { createSignal } from 'solid-js'

export interface FieldArrayItem {
  key: string
}

const createField = (): FieldArrayItem => ({
  key: crypto.randomUUID(),
})

export const useFieldArray = () => {
  const [fields, setFields] = createSignal<FieldArrayItem[]>([createField()])

  const append = () => {
    setFields((prev) => [...prev, createField()])
  }

  const remove = (key: string) => {
    setFields((prev) => {
      if (prev.length <= 1) {
        return prev
      }

      return prev.filter((field) => field.key !== key)
    })
  }

  return {
    fields,
    append,
    remove,
  }
}
