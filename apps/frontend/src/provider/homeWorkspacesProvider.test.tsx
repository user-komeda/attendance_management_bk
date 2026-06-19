import { renderHook } from '@solidjs/testing-library'
import { describe, it, expect } from 'vitest'

import {
  useHomeWorkspaces,
  HomeWorkspacesContext,
  HomeWorkspacesContextValue,
} from '~/provider/homeWorkspacesProvider'
import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'

describe('useHomeWorkspaces', () => {
  it('Providerの外で使用した場合にエラーを投げること', () => {
    expect(() => renderHook(() => useHomeWorkspaces())).toThrow(
      'useHomeWorkspaces must be used within HomeWorkspacesContext.Provider',
    )
  })

  it('Providerの中で使用した場合にcontextを返すこと', () => {
    const mockValue: HomeWorkspacesContextValue = {
      workspaces: () => ({}) as unknown as ListWorkSpacesResponse,
      isLoading: () => false,
      fetchWorkspaces: async () => ({}) as unknown as ListWorkSpacesResponse,
    }

    const { result } = renderHook(() => useHomeWorkspaces(), {
      wrapper: (props) => (
        <HomeWorkspacesContext.Provider value={mockValue}>
          {props.children}
        </HomeWorkspacesContext.Provider>
      ),
    })

    expect(result).toBe(mockValue)
  })
})
