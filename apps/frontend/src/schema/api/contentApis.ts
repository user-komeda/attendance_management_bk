import type { components } from '~/schema/apiTypes'

import type { DeepCamelCase } from '~/types/camelCase'

import type { operations } from '~/schema/apiTypes'

export type ContentApi = DeepCamelCase<components['schemas']['ContentApi']>

export type CreateContentApiPathParams =
  operations['createContentApi']['parameters']['path']

export type GetContentApiPathParams =
  operations['getContentApi']['parameters']['path']

export type DeleteContentApiPathParams =
  operations['deleteContentApi']['parameters']['path']

export type UpdateContentApiPathParams =
  operations['updateContentApi']['parameters']['path']
