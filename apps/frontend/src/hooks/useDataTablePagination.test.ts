import { createRoot, createSignal } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { useDataTablePagination } from '~/hooks/useDataTablePagination'

describe('useDataTablePagination', () => {
  const defaultMeta = {
    page: 1,
    perPage: 10,
    totalPages: 3,
    totalCount: 30,
  }

  it('paginationMetaで初期化すること', () => {
    createRoot((dispose) => {
      const [meta] = createSignal(defaultMeta)
      const { pagination, pageCount } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      expect(pagination()).toEqual({ pageIndex: 0, pageSize: 10 })
      expect(pageCount()).toBe(3)

      dispose()
    })
  })

  it('paginationMetaが変わったときpaginationを更新すること', async () => {
    await createRoot((dispose) => {
      const [meta, setMeta] = createSignal(defaultMeta)
      const { pagination } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      setMeta({ ...defaultMeta, page: 2 })

      return new Promise<void>((resolve) => {
        setTimeout(() => {
          expect(pagination()).toEqual({ pageIndex: 1, pageSize: 10 })
          dispose()
          resolve()
        }, 0)
      })
    })
  })

  it('次ページに進むこと', () => {
    createRoot((dispose) => {
      const [meta] = createSignal(defaultMeta)
      const onPageChange = vi.fn()

      const { handleNextPage, canNextPage, pagination } =
        useDataTablePagination({
          paginationMeta: meta,
          onPageChange,
          onPageSizeChange: vi.fn(),
        })

      expect(canNextPage()).toBe(true)

      handleNextPage()

      expect(pagination()).toEqual({ pageIndex: 1, pageSize: 10 })
      expect(onPageChange).toHaveBeenCalledWith(2, 10)

      dispose()
    })
  })

  it('前ページに戻ること', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({
        ...defaultMeta,
        page: 2,
      })
      const onPageChange = vi.fn()

      const { handlePreviousPage, canPreviousPage, pagination } =
        useDataTablePagination({
          paginationMeta: meta,
          onPageChange,
          onPageSizeChange: vi.fn(),
        })

      expect(canPreviousPage()).toBe(true)

      handlePreviousPage()

      expect(pagination()).toEqual({ pageIndex: 0, pageSize: 10 })
      expect(onPageChange).toHaveBeenCalledWith(1, 10)

      dispose()
    })
  })

  it('最初のページでは前ページに戻らないこと', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({
        ...defaultMeta,
        page: 1,
      })
      const onPageChange = vi.fn()

      const { handlePreviousPage, canPreviousPage } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange,
        onPageSizeChange: vi.fn(),
      })

      expect(canPreviousPage()).toBe(false)

      handlePreviousPage()

      expect(onPageChange).not.toHaveBeenCalled()

      dispose()
    })
  })

  it('最後のページでは次ページに進まないこと', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({
        ...defaultMeta,
        page: 3,
      })
      const onPageChange = vi.fn()

      const { handleNextPage, canNextPage } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange,
        onPageSizeChange: vi.fn(),
      })

      expect(canNextPage()).toBe(false)

      handleNextPage()

      expect(onPageChange).not.toHaveBeenCalled()

      dispose()
    })
  })

  it('ページサイズ変更時にpageIndexを0に戻してonPageSizeChangeを呼ぶこと', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({
        ...defaultMeta,
        page: 2,
      })
      const onPageSizeChange = vi.fn()

      const { handlePageSizeChange, pagination } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange,
      })

      handlePageSizeChange(20)

      expect(pagination()).toEqual({ pageIndex: 0, pageSize: 20 })
      expect(onPageSizeChange).toHaveBeenCalledWith(20)

      dispose()
    })
  })

  it('paginationMetaが空の場合はデフォルト値を使うこと', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({} as unknown as typeof defaultMeta)

      const { pagination, pageCount } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      expect(pagination()).toEqual({ pageIndex: 0, pageSize: 10 })
      expect(pageCount()).toBe(0)

      dispose()
    })
  })
})
