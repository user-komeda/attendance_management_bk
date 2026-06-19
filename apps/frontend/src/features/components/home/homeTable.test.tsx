import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { HomeTable } from '~/features/components/home/homeTable'
import { HomeWorkspacesContext } from '~/provider/homeWorkspacesProvider'
import { type ListWorkSpacesResponse } from '~/schema/api/workSpaces'

const basicDataTableMock = vi.hoisted(() => ({
  props: undefined as
    | {
        data: unknown[]
        paginationMeta: {
          page: number
          totalPages: number
          totalCount: number
          perPage: number
        }
        onPageChange: (page: number, perPage: number) => void
        onPageSizeChange: (pageSize: number) => void
      }
    | undefined,
}))

vi.mock('~/features/components/home/homeTableHeader', () => ({
  HomeTableHeader: () => null,
}))

vi.mock('~/components/BasicDataTable', () => ({
  BasicDataTable: (props: {
    data: unknown[]
    paginationMeta: {
      page: number
      totalPages: number
      totalCount: number
      perPage: number
    }
    onPageChange: (page: number, perPage: number) => void
    onPageSizeChange: (pageSize: number) => void
  }) => {
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
      <HomeWorkspacesContext.Provider
        value={{
          workspaces: () => undefined,
          isLoading: () => true,
          fetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </HomeWorkspacesContext.Provider>
    ))

    expect(screen.getByText('Loading...')).toBeInTheDocument()
    expect(basicDataTableMock.props).toBeUndefined()
  })

  it('workspacesのdataが空の場合はBasicDataTableに空配列とpaginationMetaを渡すこと', () => {
    render(() => (
      <HomeWorkspacesContext.Provider
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
          isLoading: () => false,
          fetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </HomeWorkspacesContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props?.data).toEqual([])
    expect(basicDataTableMock.props?.paginationMeta).toEqual({
      page: 1,
      totalPages: 1,
      totalCount: 0,
      perPage: 10,
    })
  })

  it('workspacesのdataがない場合はfallbackの空配列をBasicDataTableに渡すこと', () => {
    render(() => (
      <HomeWorkspacesContext.Provider
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
          isLoading: () => false,
          fetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </HomeWorkspacesContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props?.data).toEqual([])
    expect(basicDataTableMock.props?.paginationMeta).toEqual({
      page: 1,
      totalPages: 1,
      totalCount: 0,
      perPage: 10,
    })
  })

  it('workspacesのmetaがない場合はfallbackのpaginationMetaをBasicDataTableに渡すこと', () => {
    render(() => (
      <HomeWorkspacesContext.Provider
        value={{
          workspaces: () =>
            ({
              data: [],
              meta: undefined,
            }) as unknown as ListWorkSpacesResponse,
          isLoading: () => false,
          fetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </HomeWorkspacesContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props?.data).toEqual([])
    expect(basicDataTableMock.props?.paginationMeta).toEqual({
      page: 1,
      totalPages: 0,
      totalCount: 0,
      perPage: 10,
    })
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
      <HomeWorkspacesContext.Provider
        value={{
          workspaces: () => workspaces,
          isLoading: () => false,
          fetchWorkspaces: async () => undefined,
        }}
      >
        <HomeTable />
      </HomeWorkspacesContext.Provider>
    ))

    expect(screen.getByTestId('basic-data-table')).toBeInTheDocument()
    expect(basicDataTableMock.props?.data).toEqual(workspaces.data)
    expect(basicDataTableMock.props?.paginationMeta).toEqual(workspaces.meta)
    expect(typeof basicDataTableMock.props?.onPageChange).toBe('function')
    expect(typeof basicDataTableMock.props?.onPageSizeChange).toBe('function')
  })
})
