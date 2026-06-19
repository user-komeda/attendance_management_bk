import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

import type { operations } from '~/schema/apiTypes'

export type User = DeepCamelCase<components['schemas']['User']>

export type CreateUserRequest = DeepCamelCase<
  components['schemas']['CreateUserRequest']
>

export type UpdateUserRequest = DeepCamelCase<
  components['schemas']['UpdateUserRequest']
>

export type ListUsersResponse = DeepCamelCase<
  components['schemas']['ListUsersResponse']
>

export type GetUserPathParams = operations['getUser']['parameters']['path']

export type UpdateUserPathParams =
  operations['updateUser']['parameters']['path']
