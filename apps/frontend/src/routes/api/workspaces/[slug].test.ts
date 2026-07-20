import { describe, it, expect, vi, beforeEach } from 'vitest'

const mockGetCurrentUserId = vi.hoisted(() => vi.fn())
const mockFetchWrapper = vi.hoisted(() => vi.fn())

vi.mock('~/lib/getCurrentUserId', () => ({
  default: mockGetCurrentUserId,
}))

vi.mock('~/util/fetchWrapper', () => ({
  default: mockFetchWrapper,
}))

describe('GET /api/workspaces/[slug]', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const makeEvent = (slug: string | undefined) => ({
    params: { slug },
  })

  it('userIdがない場合は401を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue(null)
    const { GET } = await import('~/routes/api/workspaces/[slug]')

    const res = await GET(makeEvent('test-slug') as never)
    expect(res.status).toBe(401)
  })

  it('slugがない場合は400を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    const { GET } = await import('~/routes/api/workspaces/[slug]')

    const res = await GET(makeEvent(undefined) as never)
    expect(res.status).toBe(400)
  })

  it('fetchWrapperが失敗した場合はエラーレスポンスを返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    mockFetchWrapper.mockResolvedValue({
      ok: false,
      status: 500,
      error: { message: 'Server Error' },
    })
    const { GET } = await import('~/routes/api/workspaces/[slug]')

    const res = await GET(makeEvent('test-slug') as never)
    expect(res.status).toBe(500)
  })

  it('成功した場合は200を返すこと', async () => {
    mockGetCurrentUserId.mockResolvedValue('user-1')
    mockFetchWrapper.mockResolvedValue({
      ok: true,
      status: 200,
      data: { id: 'ws-1', name: 'Workspace 1' },
    })
    const { GET } = await import('~/routes/api/workspaces/[slug]')

    const res = await GET(makeEvent('test-slug') as never)
    expect(res.status).toBe(200)
  })
})
