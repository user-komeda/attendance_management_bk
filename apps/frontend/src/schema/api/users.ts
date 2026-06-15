import type { components, operations } from '~/schema/apiTypes'

export type User = components['schemas']['User']

export type CreateUserRequest = components['schemas']['CreateUserRequest']

export type UpdateUserRequest = components['schemas']['UpdateUserRequest']

export type ListUsersResponse = components['schemas']['ListUsersResponse']

export type GetUserPathParams = operations['getUser']['parameters']['path']

export type UpdateUserPathParams =
  operations['updateUser']['parameters']['path']
