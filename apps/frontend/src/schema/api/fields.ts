import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type Field = DeepCamelCase<components['schemas']['Field']>
