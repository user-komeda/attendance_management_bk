import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type SigninRequest = DeepCamelCase<
  components['schemas']['SigninRequest']
>

export type SigninResponse = DeepCamelCase<
  components['schemas']['SigninResponse']
>
