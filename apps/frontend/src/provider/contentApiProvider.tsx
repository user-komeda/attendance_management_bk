import {
  Accessor,
  createContext,
  createResource,
  JSX,
  useContext,
} from 'solid-js'

import bffFetchWrapper from '~/util/bffFetchWrapper'

export interface ContentApi {
  id: string
  name: string
  endpoint: string
  workSpaceId?: string
}

export interface ListContentApisResponse {
  data: ContentApi[]
}

export const fetchContentApisRequest = async () => {
  const result = await bffFetchWrapper<ListContentApisResponse>({
    path: '/api/content-apis',
    method: 'GET',
  })

  if (!result.ok) {
    throw new Error('Failed to load content apis')
  }

  return result.data ?? { data: [] }
}

export interface ContentApiContextValue {
  contentApis: Accessor<ListContentApisResponse | undefined>
  isLoadingContentApis: Accessor<boolean>
  refetchContentApis: () => Promise<ListContentApisResponse | null | undefined>
}

export const ContentApiContext = createContext<ContentApiContextValue>()

interface ContentApiProviderProps {
  children: JSX.Element
}

export const ContentApiProvider = (props: ContentApiProviderProps) => {
  const [contentApis, { refetch }] = createResource<ListContentApisResponse>(
    fetchContentApisRequest,
  )

  const isLoadingContentApis = () => contentApis.loading

  const refetchContentApis = async (): Promise<
    ListContentApisResponse | null | undefined
  > => {
    return refetch()
  }

  return (
    <ContentApiContext.Provider
      value={{
        contentApis,
        isLoadingContentApis,
        refetchContentApis,
      }}
    >
      {props.children}
    </ContentApiContext.Provider>
  )
}

export const useContentApi = () => {
  const context = useContext(ContentApiContext)

  if (!context) {
    throw new Error('useContentApi must be used within ContentApiProvider')
  }

  return context
}
