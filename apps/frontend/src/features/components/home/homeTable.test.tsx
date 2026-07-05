import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { HomeTable } from '~/features/components/home/homeTable'
import { WorkspaceContext } from '~/provider/workspacesProvider'
import { type ListWorkSpacesResponse } from '~/schema/api/workSpaces'

const basicDataTableMock = vi.hoisted(() => ({
  props: undefined as Record<string, unknown> | undefined,
}))

vi.mock('~/features/components/home/homeTablePrevArea', () => ({
  HomeTableHeader: () => null,
}))

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useNavigate: () => () => {
      /* empty */
    },
  }
})

vi.mock('~/components/table/BasicDataTable', () => ({
  BasicDataTable: (props: Record<string, unknown>) => {
    basicDataTableMock.props = props
    return <div data-testid="basic-data-table" />
  },
}))

describe('HomeTable', () => {
  beforeEach(() => {
    basicDataTableMock.props = undefined
  })

  it('workspacesがない場合はLoadingを表示すること', () => {
    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () => undefined,
          isLoadingWorkspaces: () => true,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeUndefined()
  })

  it('workspacesのdataが空の場合はBasicDataTableに空配列とpaginationMetaを渡すこと', () => {
    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () => ({
            data: [],
            meta: {
              page: 1,
              totalPages: 1,
              totalCount: 0,
              perPage: 10,
            },
          }),
          isLoadingWorkspaces: () => false,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeDefined()
  })

  it('workspacesのdataがない場合はfallbackの空配列をBasicDataTableに渡すこと', () => {
    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () =>
            ({
              data: undefined,
              meta: {
                page: 1,
                totalPages: 1,
                totalCount: 0,
                perPage: 10,
              },
            }) as unknown as ListWorkSpacesResponse,
          isLoadingWorkspaces: () => false,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeDefined()
  })

  it('workspacesのmetaがない場合はfallbackのpaginationMetaをBasicDataTableに渡すこと', () => {
    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () =>
            ({
              data: [],
              meta: undefined,
            }) as unknown as ListWorkSpacesResponse,
          isLoadingWorkspaces: () => false,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeDefined()
  })

  it('workspacesのdataがある場合はBasicDataTableにdataとpaginationMetaを渡すこと', () => {
    const workspaces = {
      data: [
        {
          id: 'workspace-1',
          name: 'Workspace 1',
          slug: 'ws-1',
          status: 'active',
        },
        {
          id: 'workspace-2',
          name: 'Workspace 2',
          slug: 'ws-2',
          status: 'active',
        },
      ],
      meta: {
        page: 1,
        totalPages: 1,
        totalCount: 2,
        perPage: 10,
      },
    }

    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () => workspaces,
          isLoadingWorkspaces: () => false,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeDefined()
  })

  it('BasicDataTableに渡したgetRowHrefでワークスペース詳細URLを生成すること', () => {
    const workspace = {
      id: 'workspace-1',
      name: 'Workspace 1',
      slug: 'ws-1',
      status: 'active',
    }

    render(() => (
      <WorkspaceContext.Provider
        value={{
          workspaces: () => ({
            data: [workspace],
            meta: {
              page: 1,
              totalPages: 1,
              totalCount: 1,
              perPage: 10,
            },
          }),
          isLoadingWorkspaces: () => false,
          refetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </WorkspaceContext.Provider>
    ))

    const getRowHref = basicDataTableMock.props?.getRowHref as
      | ((row: typeof workspace) => string)
      | undefined

    expect(getRowHref?.(workspace)).toBe('/workspaces/workspace-1')
  })
})
