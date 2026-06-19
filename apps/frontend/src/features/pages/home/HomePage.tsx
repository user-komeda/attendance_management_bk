import { createResource } from 'solid-js'

import { HomeTable } from '~/features/components/home/homeTable'
import { HomeWorkspacesContext } from '~/provider/homeWorkspacesProvider'
import { PaginationMeta } from '~/schema/api/paginationMetas'
import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import bffFetchWrapper from '~/util/bffFetchWrapper'

export type FetchWorkspacesParams = Partial<
  Omit<PaginationMeta, 'totalPages' | 'totalCount'>
>
export const fetchWorkspacesRequest = async (
  params?: FetchWorkspacesParams,
) => {
  const searchParams = new URLSearchParams()

  if (params?.searchQuery) {
    searchParams.set('search_query', params.searchQuery)
  }

  if (params?.page) {
    searchParams.set('page', params.page.toString())
  }

  if (params?.perPage) {
    searchParams.set('per_page', params.perPage.toString())
  }

  const path = searchParams.toString()
    ? `/api/workspaces?${searchParams.toString()}`
    : '/api/workspaces'

  const result = await bffFetchWrapper<ListWorkSpacesResponse>(path, 'GET')

  if (!result.ok) {
    throw new Error('Failed to load workspaces')
  }

  return (
    result.data ?? {
      data: [],
      meta: { page: 1, totalPages: 0, totalCount: 0, perPage: 10 },
    }
  )
}

export const HomePage = (props: {
  children?: import('solid-js').JSX.Element
}) => {
  const [workspaces, { refetch }] = createResource<ListWorkSpacesResponse>(
    (_, info) =>
      fetchWorkspacesRequest(
        info.refetching as FetchWorkspacesParams | undefined,
      ),
  )

  const isLoading = () => workspaces.loading
  const fetchWorkspaces = async (
    params?: FetchWorkspacesParams,
  ): Promise<ListWorkSpacesResponse | null | undefined> => {
    return refetch(params)
  }

  return (
    <HomeWorkspacesContext.Provider
      value={{
        workspaces,
        isLoading,
        fetchWorkspaces,
      }}
    >
      {props.children || <HomeTable />}
    </HomeWorkspacesContext.Provider>
  )
}
