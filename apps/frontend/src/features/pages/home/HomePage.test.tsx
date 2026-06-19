import { render, waitFor } from '@solidjs/testing-library'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import {
  HomePage,
  fetchWorkspacesRequest,
} from '~/features/pages/home/HomePage'
import { type ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import bffFetchWrapper from '~/util/bffFetchWrapper'

vi.mock('~/util/bffFetchWrapper')

vi.mock('~/features/components/home/homeTable', () => ({
  HomeTable: () => null,
}))

describe('HomePage', () => {
  const mockWorkspaces = {
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
    meta: { page: 1, totalPages: 1, totalCount: 2, perPage: 10 },
  }

  beforeEach(() => {
    vi.clearAllMocks()
  })

  describe('fetchWorkspacesRequest', () => {
    it('search queryを指定した場合、search_query付きでリクエストすること', async () => {
      vi.mocked(bffFetchWrapper).mockResolvedValue({
        ok: true,
        status: 200,
        data: mockWorkspaces,
      })

      await fetchWorkspacesRequest({ searchQuery: 'test' })

      expect(bffFetchWrapper).toHaveBeenCalledWith(
        expect.stringContaining('search_query=test'),
        'GET',
      )
    })

    it('pageとperPageを指定した場合、pageとper_page付きでリクエストすること', async () => {
      vi.mocked(bffFetchWrapper).mockResolvedValue({
        ok: true,
        status: 200,
        data: mockWorkspaces,
      })

      await fetchWorkspacesRequest({ page: 2, perPage: 20 })

      expect(bffFetchWrapper).toHaveBeenCalledWith(
        '/api/workspaces?page=2&per_page=20',
        'GET',
      )
    })

    it('リクエストが失敗した場合、エラーをthrowすること', async () => {
      vi.mocked(bffFetchWrapper).mockResolvedValue({
        ok: false,
        status: 500,
        error: {
          message: 'Internal Server Error',
          fieldErrors: [],
        },
      })

      await expect(fetchWorkspacesRequest()).rejects.toThrow(
        'Failed to load workspaces',
      )
    })

    it('レスポンスのdataがnullの場合、空の一覧を返すこと', async () => {
      vi.mocked(bffFetchWrapper).mockResolvedValue({
        ok: true,
        status: 200,
        data: null as unknown as ListWorkSpacesResponse,
      })

      const result = await fetchWorkspacesRequest()

      expect(result.data).toEqual([])
      expect(result.meta).toEqual({
        page: 1,
        totalPages: 0,
        totalCount: 0,
        perPage: 10,
      })
    })
  })

  describe('HomePage Component', () => {
    it('初回表示時にワークスペース一覧を取得すること', async () => {
      vi.mocked(bffFetchWrapper).mockResolvedValue({
        ok: true,
        status: 200,
        data: mockWorkspaces,
      })

      render(() => <HomePage />)

      await waitFor(() => {
        expect(bffFetchWrapper).toHaveBeenCalledWith(
          '/api/workspaces?per_page=10',
          'GET',
        )
      })
    })
  })
})
