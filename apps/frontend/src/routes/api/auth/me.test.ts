import { describe, it, expect, vi } from 'vitest'

import getCurrentUserId from '~/lib/getCurrentUserId'
import { GET } from '~/routes/api/auth/me'

vi.mock('~/lib/getCurrentUserId', () => ({
  default: vi.fn(),
}))

describe('me api', () => {
  it('未ログインの場合はauthenticated: falseを返すこと', async () => {
    vi.mocked(getCurrentUserId).mockResolvedValue(null)

    const response = await GET()
    expect(response.status).toBe(401)
    const body = await response.json()
    expect(body.authenticated).toBe(false)
  })

  it('ログイン済みの場合はauthenticated: trueを返すこと', async () => {
    vi.mocked(getCurrentUserId).mockResolvedValue('user-123')

    const response = await GET()
    expect(response.status).toBe(200)
    const body = await response.json()
    expect(body.authenticated).toBe(true)
  })
})
