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

  const perPage = params?.perPage ?? 10
  searchParams.set('per_page', perPage.toString())

  const path = `/api/workspaces?${searchParams.toString()}`
  const result = await bffFetchWrapper<ListWorkSpacesResponse>({
    path,
    method: 'GET',
  })

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

export const HomePage = () => {
  const [workspaces, { refetch }] = createResource<ListWorkSpacesResponse>(
    (_, info) =>
      fetchWorkspacesRequest(
        info.refetching as FetchWorkspacesParams | undefined,
      ),
  )

  // 単体での確認が難しいのでskip
  /* v8 ignore start */
  const isLoading = () => workspaces.loading
  /* v8 ignore stop */

  // 単体での確認が難しいのでskip
  /* v8 ignore start */
  const fetchWorkspaces = async (
    params?: FetchWorkspacesParams,
  ): Promise<ListWorkSpacesResponse | null | undefined> => {
    return refetch(params)
  }
  /* v8 ignore stop */
  return (
    <HomeWorkspacesContext.Provider
      value={{
        workspaces,
        isLoading,
        fetchWorkspaces,
      }}
    >
      <HomeTable />
    </HomeWorkspacesContext.Provider>
  )
}
