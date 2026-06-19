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

  it('initializes with pagination meta', () => {
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

  it('updates pagination when meta changes', () => {
    createRoot((dispose) => {
      const [meta, setMeta] = createSignal(defaultMeta)
      const { pagination } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      setMeta({ ...defaultMeta, page: 2 })
      // Use a timeout or Promise to wait for the effect
      return new Promise<void>((resolve) => {
        setTimeout(() => {
          expect(pagination()).toEqual({ pageIndex: 1, pageSize: 10 })
          dispose()
          resolve()
        }, 0)
      })
    })
  })

  it('handles next and previous page', () => {
    createRoot((dispose) => {
      const [meta] = createSignal(defaultMeta)
      const onPageChange = vi.fn()
      const {
        handleNextPage,
        handlePreviousPage,
        canNextPage,
        canPreviousPage,
        pagination,
      } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange,
        onPageSizeChange: vi.fn(),
      })

      expect(canPreviousPage()).toBe(false)
      expect(canNextPage()).toBe(true)

      handleNextPage()
      expect(pagination().pageIndex).toBe(1)
      expect(onPageChange).toHaveBeenCalledWith(2, 10)

      expect(canPreviousPage()).toBe(true)
      handlePreviousPage()
      expect(pagination().pageIndex).toBe(0)
      expect(onPageChange).toHaveBeenCalledWith(1, 10)

      dispose()
    })
  })

  it('does not change page if cannot move', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({ ...defaultMeta, totalPages: 1 })
      const onPageChange = vi.fn()
      const { handleNextPage, handlePreviousPage } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange,
        onPageSizeChange: vi.fn(),
      })

      handleNextPage()
      handlePreviousPage()
      expect(onPageChange).not.toHaveBeenCalled()
      dispose()
    })
  })

  it('handles page size change', () => {
    createRoot((dispose) => {
      const [meta] = createSignal(defaultMeta)
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

  it('uses default values when meta is empty', () => {
    createRoot((dispose) => {
      const [meta] = createSignal({} as unknown as typeof defaultMeta)
      const { pagination } = useDataTablePagination({
        paginationMeta: meta,
        onPageChange: vi.fn(),
        onPageSizeChange: vi.fn(),
      })

      expect(pagination()).toEqual({ pageIndex: 0, pageSize: 10 })
      dispose()
    })
  })
})
