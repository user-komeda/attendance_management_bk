import { describe, it, expect, vi, beforeEach } from 'vitest'

const mockGetCurrentUserId = vi.hoisted(() => vi.fn())
const mockFetchWrapper = vi.hoisted(() => vi.fn())

vi.mock('~/lib/getCurrentUserId', () => ({
  default: mockGetCurrentUserId,
}))

vi.mock('~/util/fetchWrapper', () => ({
  default: mockFetchWrapper,
}))

describe('POST /api/workspaces/[slug]/contentApi', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const makeEvent = (slug: string | undefined, body: unknown) => ({
    params: { slug },
    request: {
      json: async () => body,
    },
  })

  it('userIdがない場合は401を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue(null)
    const { POST } = await import('~/routes/api/workspaces/[slug]/contentApi')

    const res = await POST(makeEvent('test-slug', {}) as never)
    expect(res.status).toBe(401)
  })

  it('slugがない場合は400を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    const { POST } = await import('~/routes/api/workspaces/[slug]/contentApi')

    const res = await POST(makeEvent(undefined, {}) as never)
    expect(res.status).toBe(400)
  })

  it('バリデーション失敗の場合は400を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    const { POST } = await import('~/routes/api/workspaces/[slug]/contentApi')

    const res = await POST(makeEvent('test-slug', { invalid: 'data' }) as never)
    expect(res.status).toBe(400)
  })

  it('fetchWrapperが失敗した場合はエラーレスポンスを返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    mockFetchWrapper.mockResolvedValue({
      ok: false,
      status: 500,
      error: { message: 'Server Error', fieldErrors: [] },
    })
    const { POST } = await import('~/routes/api/workspaces/[slug]/contentApi')

    const res = await POST(
      makeEvent('test-slug', {
        name: 'test',
        endpoint: 'test-endpoint',
        apiType: 'list',
      }) as never,
    )
    expect(res.status).toBe(500)
  })

  it('成功した場合は200を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    mockFetchWrapper.mockResolvedValue({
      ok: true,
      status: 200,
      data: { id: 'content-1' },
    })
    const { POST } = await import('~/routes/api/workspaces/[slug]/contentApi')

    const res = await POST(
      makeEvent('test-slug', {
        name: 'test',
        endpoint: 'test-endpoint',
        apiType: 'list',
      }) as never,
    )
    expect(res.status).toBe(200)
  })
})
