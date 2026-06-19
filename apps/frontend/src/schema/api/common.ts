import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type ApiError = DeepCamelCase<components['schemas']['Error']>
