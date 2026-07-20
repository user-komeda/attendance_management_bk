import * as v from 'valibot'
import { describe, it, expect, vi, beforeEach } from 'vitest'

const mockAction = vi.hoisted(() =>
  vi.fn((fn: unknown, name?: string) => ({
    fn,
    name,
    with: (param: unknown) => [param],
  })),
)

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    action: mockAction,
  }
})

const mockHandleFetchResult = vi.hoisted(() => vi.fn())
const mockParseFormData = vi.hoisted(() => vi.fn())

vi.mock('~/util/actionWrapperCommon', () => ({
  handleFetchResult: mockHandleFetchResult,
  parseFormData: mockParseFormData,
}))

describe('actionWrapperWithParams', () => {
  const TestSchema = v.object({
    name: v.string(),
  })

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('actionを呼び出してラッパーを返すこと', async () => {
    const actionWrapperWithParam = (
      await import('~/util/actionWrapperWithParams')
    ).default
    actionWrapperWithParam({
      path: (slug: string) => `/api/workspaces/${slug}/contentApi`,
      method: 'POST',
      schema: TestSchema,
      redirectUrl: '/',
      name: 'test-action',
    })

    expect(mockAction).toHaveBeenCalledWith(expect.any(Function), 'test-action')
  })

  it('parseFormDataが失敗した場合はエラー結果を返すこと', async () => {
    const actionWrapperWithParam = (
      await import('~/util/actionWrapperWithParams')
    ).default
    const errorResult = { ok: false, fieldErrors: [], message: 'error' }
    mockParseFormData.mockReturnValue({ success: false, result: errorResult })

    actionWrapperWithParam({
      path: (slug: string) => `/api/workspaces/${slug}/contentApi`,
      method: 'POST',
      schema: TestSchema,
    })

    const actionFn = mockAction.mock.calls[0][0] as (
      param: string,
      formData: FormData,
    ) => Promise<unknown>
    const formData = new FormData()
    const result = await actionFn('test-slug', formData)

    expect(result).toEqual(errorResult)
    expect(mockHandleFetchResult).not.toHaveBeenCalled()
  })

  it('parseFormDataが成功した場合はhandleFetchResultを呼び出すこと', async () => {
    const actionWrapperWithParam = (
      await import('~/util/actionWrapperWithParams')
    ).default
    const output = { name: 'test' }
    mockParseFormData.mockReturnValue({ success: true, output })
    mockHandleFetchResult.mockResolvedValue({ ok: true })

    actionWrapperWithParam({
      path: (slug: string) => `/api/workspaces/${slug}/contentApi`,
      method: 'POST',
      schema: TestSchema,
      redirectUrl: '/',
    })

    const actionFn = mockAction.mock.calls[0][0] as (
      param: string,
      formData: FormData,
    ) => Promise<unknown>
    const formData = new FormData()
    const result = await actionFn('test-slug', formData)

    expect(mockHandleFetchResult).toHaveBeenCalledWith({
      path: '/api/workspaces/test-slug/contentApi',
      method: 'POST',
      output,
      redirectUrl: '/',
    })
    expect(result).toEqual({ ok: true })
  })
})
