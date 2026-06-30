import { useParams } from '@solidjs/router'

import { CreateForm } from '~/features/components/workspaces/contentApi/createForm'
import { CreateContentApiSchema } from '~/schema/contentApi/createContentApiSchhema'
import actionWrapperWithParam from '~/util/actionWrapperWithParams'

const createContentApi = actionWrapperWithParam<
  typeof CreateContentApiSchema,
  string
>({
  // v8 ignore next
  path: (slug) => `/api/workspaces/${slug}/contentApi`,
  method: 'POST',
  schema: CreateContentApiSchema,
  redirectUrl: '/',
  name: 'api-content',
})

export const WorkspaceDetail = () => {
  const params = useParams()
  const slug = params.slug

  if (slug === undefined) {
    return null
  }

  // v8 ignore next
  return <CreateForm action={createContentApi.with(slug)} />
}
