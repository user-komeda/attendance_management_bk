import {
  Accessor,
  createContext,
  createResource,
  JSX,
  useContext,
} from 'solid-js'

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
      meta: { page: 1, totalPages: 0, totalCount: 0, perPage },
    }
  )
}

export interface WorkspaceContextValue {
  workspaces: Accessor<ListWorkSpacesResponse | undefined>
  isLoadingWorkspaces: Accessor<boolean>
  refetchWorkspaces: (
    params?: FetchWorkspacesParams,
  ) => Promise<ListWorkSpacesResponse | null | undefined>
}

export const WorkspaceContext = createContext<WorkspaceContextValue>()

interface WorkspaceProviderProps {
  children: JSX.Element
}

export const WorkspaceProvider = (props: WorkspaceProviderProps) => {
  const [workspaces, { refetch }] = createResource<ListWorkSpacesResponse>(
    (_, info) =>
      fetchWorkspacesRequest(
        info.refetching as FetchWorkspacesParams | undefined,
      ),
  )

  const isLoadingWorkspaces = () => workspaces.loading

  const refetchWorkspaces = async (
    params?: FetchWorkspacesParams,
  ): Promise<ListWorkSpacesResponse | null | undefined> => {
    return refetch(params)
  }

  return (
    <WorkspaceContext.Provider
      value={{
        workspaces,
        isLoadingWorkspaces,
        refetchWorkspaces,
      }}
    >
      {props.children}
    </WorkspaceContext.Provider>
  )
}

export const useWorkspace = () => {
  const context = useContext(WorkspaceContext)

  if (!context) {
    throw new Error('useWorkspace must be used within WorkspaceProvider')
  }

  return context
}
