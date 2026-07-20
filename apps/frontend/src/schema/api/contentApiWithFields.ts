import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type ContentApiWithFields = DeepCamelCase<
  components['schemas']['ContentApiWithFields']
>

export type CreateContentApiWithFieldsRequest = DeepCamelCase<
  components['schemas']['CreateContentApiWithFieldsRequest']
>

export type UpdateContentApiWithFieldsRequest = DeepCamelCase<
  components['schemas']['UpdateContentApiWithFieldsRequest']
>
