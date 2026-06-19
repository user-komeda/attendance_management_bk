import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

import type { operations } from '~/schema/apiTypes'

export type WorkSpace = DeepCamelCase<components['schemas']['WorkSpace']>

export type WorkSpaceWithStatus = DeepCamelCase<
  components['schemas']['WorkSpaceWithStatus']
>

export type WorkSpaceWithMemberShips = DeepCamelCase<
  components['schemas']['WorkSpaceWithMemberShips']
>

export type CreateWorkSpaceRequest = DeepCamelCase<
  components['schemas']['CreateWorkSpaceRequest']
>

export type UpdateWorkSpaceRequest = DeepCamelCase<
  components['schemas']['UpdateWorkSpaceRequest']
>

export type ListWorkSpacesResponse = DeepCamelCase<
  components['schemas']['ListWorkSpacesResponse']
>

export type ListWorkSpacesQueryParams =
  operations['listWorkSpaces']['parameters']['query']

export type GetWorkSpacePathParams =
  operations['getWorkSpace']['parameters']['path']

export type DeleteWorkSpacePathParams =
  operations['deleteWorkSpace']['parameters']['path']

export type UpdateWorkSpacePathParams =
  operations['updateWorkSpace']['parameters']['path']
