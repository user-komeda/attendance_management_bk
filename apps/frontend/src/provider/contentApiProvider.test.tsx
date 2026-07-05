import { render, screen, waitFor } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import {
  useContentApi,
  ContentApiProvider,
  fetchContentApisRequest,
} from '~/provider/contentApiProvider'

vi.mock('~/util/bffFetchWrapper', () => ({
  default: vi.fn().mockResolvedValue({
    ok: true,
    data: {
      data: [{ id: '1', name: 'API1', endpoint: '/api/1' }],
    },
  }),
}))

describe('contentApiProvider', () => {
  it('useContentApi throws error when used outside provider', () => {
    expect(() => useContentApi()).toThrow(
      'useContentApi must be used within ContentApiProvider',
    )
  })

  it('ContentApiProvider provides contentApis to children', async () => {
    const TestComponent = () => {
      const { contentApis } = useContentApi()
      return <div>{contentApis()?.data[0]?.name ?? 'loading'}</div>
    }

    render(() => (
      <ContentApiProvider>
        <TestComponent />
      </ContentApiProvider>
    ))

    await waitFor(() => expect(screen.getByText('API1')).toBeInTheDocument())
  })

  it('ContentApiProvider provides isLoadingContentApis', async () => {
    const TestComponent = () => {
      const { isLoadingContentApis } = useContentApi()
      return <div>{isLoadingContentApis() ? 'loading' : 'done'}</div>
    }

    render(() => (
      <ContentApiProvider>
        <TestComponent />
      </ContentApiProvider>
    ))

    await waitFor(() => expect(screen.getByText('done')).toBeInTheDocument())
  })

  it('ContentApiProvider refetchContentApis works', async () => {
    const TestComponent = () => {
      const { contentApis, refetchContentApis } = useContentApi()
      return (
        <div>
          <div>{contentApis()?.data[0]?.name ?? 'loading'}</div>
          <button onClick={() => refetchContentApis()}>Refetch</button>
        </div>
      )
    }

    render(() => (
      <ContentApiProvider>
        <TestComponent />
      </ContentApiProvider>
    ))

    await waitFor(() => expect(screen.getByText('API1')).toBeInTheDocument())
    screen.getByRole('button').click()
    await waitFor(() => expect(screen.getByText('API1')).toBeInTheDocument())
  })
})

describe('fetchContentApisRequest', () => {
  it('正常にデータを取得すること', async () => {
    const result = await fetchContentApisRequest()
    expect(result.data[0].name).toBe('API1')
  })

  it('result.okがfalseの場合エラーをスローすること', async () => {
    const bffFetchWrapper = (await import('~/util/bffFetchWrapper')).default
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({ ok: false } as never)
    await expect(fetchContentApisRequest()).rejects.toThrow(
      'Failed to load content apis',
    )
  })

  it('result.dataがnullの場合デフォルト値を返すこと', async () => {
    const bffFetchWrapper = (await import('~/util/bffFetchWrapper')).default
    vi.mocked(bffFetchWrapper).mockResolvedValueOnce({
      ok: true,
      data: null,
    } as never)
    const result = await fetchContentApisRequest()
    expect(result.data).toEqual([])
  })
})
