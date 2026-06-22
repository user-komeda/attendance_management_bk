import { describe, it, expect, vi } from 'vitest'

import getCurrentUserId from '~/lib/getCurrentUserId'
import { GET, POST } from '~/routes/api/(workspaces)/workspaces'
import fetchWrapper from '~/util/fetchWrapper'

vi.mock('~/lib/getCurrentUserId', () => ({
  default: vi.fn(),
}))

vi.mock('~/util/fetchWrapper', () => ({
  default: vi.fn(),
}))

// eslint-disable-next-line max-lines-per-function
describe('workspaces api', () => {
  // eslint-disable-next-line max-lines-per-function
  describe('GET', () => {
    it('未ログインの場合は401を返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue(null)
      const event = {
        request: { url: 'http://localhost/api/workspaces' },
      } as unknown as Parameters<typeof GET>[0]

      const response = await GET(event)
      expect(response.status).toBe(401)
      const body = await response.json()
      expect(body.error).toContain('unauthorized')
    })

    it('ログイン済みの場合はワークスペース一覧を返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue('user-123')
      vi.mocked(fetchWrapper).mockResolvedValue({
        ok: true,
        status: 200,
        data: { data: [], meta: {} },
      } as unknown as Awaited<ReturnType<typeof fetchWrapper>>)
      const event = {
        request: {
          url: 'http://localhost/api/workspaces?page=1&per_page=10&search_query=test',
        },
      } as unknown as Parameters<typeof GET>[0]

      const response = await GET(event)
      expect(response.status).toBe(200)
      expect(fetchWrapper).toHaveBeenCalledWith({
        path: 'work_spaces?page=1&per_page=10&search_query=test',
        method: 'GET',
        userId: 'user-123',
      })
    })

    it('fetchWrapperがエラーを返した場合はそのステータスを返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue('user-123')
      vi.mocked(fetchWrapper).mockResolvedValue({
        ok: false,
        status: 400,
        error: { error: ['bad request'] },
      } as unknown as Awaited<ReturnType<typeof fetchWrapper>>)
      const event = {
        request: { url: 'http://localhost/api/workspaces' },
      } as unknown as Parameters<typeof GET>[0]

      const response = await GET(event)
      expect(response.status).toBe(400)
    })
  })

  // eslint-disable-next-line max-lines-per-function
  describe('POST', () => {
    it('未ログインの場合は401を返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue(null)
      const event = {
        request: { json: async () => ({}) },
      } as unknown as Parameters<typeof POST>[0]

      const response = await POST(event)
      expect(response.status).toBe(401)
    })

    it('バリデーションエラーの場合は400を返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue('user-123')
      const event = {
        request: {
          json: async () => ({ name: '', slug: '' }),
        },
      } as unknown as Parameters<typeof GET>[0]

      const response = await POST(event)
      expect(response.status).toBe(400)
    })

    it('正しいデータの場合はワークスペースを作成すること', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue('user-123')
      vi.mocked(fetchWrapper).mockResolvedValue({
        ok: true,
        status: 201,
        data: { id: '1' },
      } as unknown as Awaited<ReturnType<typeof fetchWrapper>>)
      const event = {
        request: {
          json: async () => ({ name: 'New Space', slug: 'new-space' }),
        },
      } as unknown as Parameters<typeof GET>[0]

      const response = await POST(event)
      expect(response.status).toBe(201)
      expect(fetchWrapper).toHaveBeenCalledWith({
        path: 'work_spaces',
        method: 'POST',
        data: { name: 'New Space', slug: 'new-space' },
        userId: 'user-123',
      })
    })

    it('作成時にfetchWrapperがエラーを返した場合はそのステータスを返すこと', async () => {
      vi.mocked(getCurrentUserId).mockResolvedValue('user-123')
      vi.mocked(fetchWrapper).mockResolvedValue({
        ok: false,
        status: 409,
        error: { error: ['conflict'] },
      } as unknown as Awaited<ReturnType<typeof fetchWrapper>>)
      const event = {
        request: {
          json: async () => ({ name: 'New Space', slug: 'new-space' }),
        },
      } as unknown as Parameters<typeof GET>[0]

      const response = await POST(event)
      expect(response.status).toBe(409)
    })
  })
})
