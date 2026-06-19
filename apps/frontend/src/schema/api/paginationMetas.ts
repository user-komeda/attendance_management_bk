import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type PaginationMeta = DeepCamelCase<
  components['schemas']['PaginationMeta']
>
