export const formDataToObject = (
  formData: FormData,
): Record<string, unknown> => {
  const rawData: Record<string, unknown> = {}
  const arrayFields: Record<string, Record<string, unknown>[]> = {}

  for (const [key, value] of formData.entries()) {
    const match = key.match(/^(\w+)\[(\d+)]\[(\w+)]$/)

    if (!match) {
      rawData[key] = value
      continue
    }

    const [, arrayKey, indexText, fieldKey] = match
    const index = Number(indexText)

    arrayFields[arrayKey] ??= []
    arrayFields[arrayKey][index] ??= {}
    arrayFields[arrayKey][index][fieldKey] = value
  }

  for (const [key, value] of Object.entries(arrayFields)) {
    rawData[key] = value
  }

  return rawData
}
