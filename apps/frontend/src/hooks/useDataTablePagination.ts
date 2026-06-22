import { PaginationState } from '@tanstack/solid-table'
import { Accessor, createEffect, createSignal } from 'solid-js'

import { PaginationMeta } from '~/schema/api/paginationMetas'

type OmitPaginationMeta = Omit<PaginationMeta, 'searchQuery'>

interface UseDataTablePaginationParams {
  paginationMeta: Accessor<OmitPaginationMeta>
  onPageChange: (page: number, perPage: number) => void
  onPageSizeChange: (pageSize: number) => void
}

const DEFAULT_PAGE = 1
const DEFAULT_PAGE_SIZE = 10

const toPaginationState = (
  paginationMeta: OmitPaginationMeta,
): PaginationState => ({
  pageIndex: Math.max((paginationMeta.page ?? DEFAULT_PAGE) - 1, 0),
  pageSize: paginationMeta.perPage ?? DEFAULT_PAGE_SIZE,
})

// eslint-disable-next-line max-lines-per-function
export const useDataTablePagination = ({
  paginationMeta,
  onPageChange,
  onPageSizeChange,
}: UseDataTablePaginationParams) => {
  const [pagination, setPagination] = createSignal<PaginationState>(
    toPaginationState(paginationMeta()),
  )

  createEffect(() => {
    setPagination(toPaginationState(paginationMeta()))
  })
  const pageCount = () => paginationMeta().totalPages ?? 0

  const canPreviousPage = () => pagination().pageIndex > 0

  const canNextPage = () => pagination().pageIndex + 1 < pageCount()

  const handlePreviousPage = () => {
    if (!canPreviousPage()) {
      return
    }

    const currentPagination = pagination()
    const nextPagination = {
      pageIndex: currentPagination.pageIndex - 1,
      pageSize: currentPagination.pageSize,
    }

    setPagination(nextPagination)
    onPageChange(nextPagination.pageIndex + 1, nextPagination.pageSize)
  }

  const handleNextPage = () => {
    if (!canNextPage()) {
      return
    }

    const currentPagination = pagination()
    const nextPagination = {
      pageIndex: currentPagination.pageIndex + 1,
      pageSize: currentPagination.pageSize,
    }

    setPagination(nextPagination)
    onPageChange(nextPagination.pageIndex + 1, nextPagination.pageSize)
  }

  const handlePageSizeChange = (pageSize: number) => {
    const nextPagination = {
      pageIndex: 0,
      pageSize,
    }

    setPagination(nextPagination)
    onPageSizeChange(pageSize)
  }

  return {
    pagination,
    pageCount,
    canPreviousPage,
    canNextPage,
    handlePreviousPage,
    handleNextPage,
    handlePageSizeChange,
  }
}
