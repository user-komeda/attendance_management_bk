import { Accessor, createContext, useContext } from 'solid-js'

import { FetchWorkspacesParams } from '~/features/pages/home/HomePage'
import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'

export interface HomeWorkspacesContextValue {
  workspaces: Accessor<ListWorkSpacesResponse | undefined>
  isLoading: Accessor<boolean>
  fetchWorkspaces: (
    params?: FetchWorkspacesParams,
  ) => Promise<ListWorkSpacesResponse | null | undefined>
}

export const HomeWorkspacesContext = createContext<HomeWorkspacesContextValue>()

export const useHomeWorkspaces = () => {
  const context = useContext(HomeWorkspacesContext)

  if (!context) {
    throw new Error(
      'useHomeWorkspaces must be used within HomeWorkspacesContext.Provider',
    )
  }

  return context
}
