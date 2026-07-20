import {
  Accessor,
  createContext,
  createResource,
  JSX,
  useContext,
} from 'solid-js'

import type { WorkSpaceWithMemberShips } from '~/schema/api/workSpaces'

import bffFetchWrapper from '~/util/bffFetchWrapper'

export const fetchWorkspaceDetailRequest = async (
  slug: string,
): Promise<WorkSpaceWithMemberShips> => {
  const result = await bffFetchWrapper<WorkSpaceWithMemberShips>({
    path: `/api/workspaces/${slug}`,
    method: 'GET',
  })

  if (!result.ok || result.data === undefined) {
    throw new Error('Failed to load workspace detail')
  }
  return result.data
}

export interface WorkspaceDetailContextValue {
  workspaceDetail: Accessor<WorkSpaceWithMemberShips | undefined>
  isLoadingWorkspaceDetail: Accessor<boolean>
  refetchWorkspaceDetail: () => Promise<
    WorkSpaceWithMemberShips | null | undefined
  >
}

export const WorkspaceDetailContext =
  createContext<WorkspaceDetailContextValue>()

interface WorkspaceDetailProviderProps {
  slug?: string
  children: JSX.Element
}

export const WorkspaceDetailProvider = (
  props: WorkspaceDetailProviderProps,
) => {
  const [workspaceDetail, { refetch }] = createResource(
    () => props.slug,
    (slug) => fetchWorkspaceDetailRequest(slug),
  )

  const isLoadingWorkspaceDetail = () => workspaceDetail.loading

  const refetchWorkspaceDetail = async (): Promise<
    WorkSpaceWithMemberShips | null | undefined
  > => {
    return refetch()
  }

  return (
    <WorkspaceDetailContext.Provider
      value={{
        workspaceDetail,
        isLoadingWorkspaceDetail,
        refetchWorkspaceDetail,
      }}
    >
      {props.children}
    </WorkspaceDetailContext.Provider>
  )
}

export const useWorkspaceDetail = () => {
  const context = useContext(WorkspaceDetailContext)

  if (!context) {
    throw new Error(
      'useWorkspaceDetail must be used within WorkspaceDetailProvider',
    )
  }

  return context
}
