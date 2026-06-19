import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

export type SignupRequest = DeepCamelCase<
  components['schemas']['SignupRequest']
>

export type SignupResponse = DeepCamelCase<
  components['schemas']['SignupResponse']
>
