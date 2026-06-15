import type { components } from '~/schema/apiTypes'

import type { operations } from '~/schema/apiTypes'

export type WorkSpace = components['schemas']['WorkSpace']

export type WorkSpaceWithStatus = components['schemas']['WorkSpaceWithStatus']

export type WorkSpaceWithMemberShips =
  components['schemas']['WorkSpaceWithMemberShips']

export type CreateWorkSpaceRequest =
  components['schemas']['CreateWorkSpaceRequest']

export type UpdateWorkSpaceRequest =
  components['schemas']['UpdateWorkSpaceRequest']

export type ListWorkSpacesResponse =
  components['schemas']['ListWorkSpacesResponse']

export type GetWorkSpacePathParams =
  operations['getWorkSpace']['parameters']['path']

export type DeleteWorkSpacePathParams =
  operations['deleteWorkSpace']['parameters']['path']

export type UpdateWorkSpacePathParams =
  operations['updateWorkSpace']['parameters']['path']
