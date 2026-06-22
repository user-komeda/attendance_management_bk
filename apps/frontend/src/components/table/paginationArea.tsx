import { PaginationProps } from '~/components/table/BasicDataTable'
import { Button } from '~/components/ui/button'

type PaginationSelectProps = Pick<
  PaginationProps,
  'pagination' | 'handlePageSizeChange'
>

type PaginationButtonsProps = Omit<PaginationProps, 'handlePageSizeChange'>

const PaginationSelect = (props: PaginationSelectProps) => {
  const { pagination, handlePageSizeChange } = props
  return (
    <div class="text-muted-foreground flex items-center gap-2 text-sm">
      <span>表示件数</span>

      <select
        class="border-input bg-background h-8 rounded-md border px-2 text-sm"
        value={pagination().pageSize}
        onChange={(e) => {
          handlePageSizeChange(Number(e.currentTarget.value))
        }}
      >
        <option value="5">5件</option>
        <option value="10">10件</option>
        <option value="20">20件</option>
        <option value="50">50件</option>
      </select>
    </div>
  )
}

const PaginationButtons = (props: PaginationButtonsProps) => {
  const {
    pagination,
    canPreviousPage,
    canNextPage,
    pageCount,
    handlePreviousPage,
    handleNextPage,
  } = props
  return (
    <div class="flex items-center gap-4">
      <div class="text-muted-foreground text-sm">
        {pagination().pageIndex + 1} / {pageCount()} ページ
      </div>

      <div class="flex items-center gap-2">
        <Button
          variant="outline"
          size="sm"
          onClick={handlePreviousPage}
          disabled={!canPreviousPage()}
        >
          Previous
        </Button>

        <Button
          variant="outline"
          size="sm"
          onClick={handleNextPage}
          disabled={!canNextPage()}
        >
          Next
        </Button>
      </div>
    </div>
  )
}

export const PaginationArea = (props: PaginationProps) => {
  const {
    pagination,
    handlePageSizeChange,
    handlePreviousPage,
    handleNextPage,
    canPreviousPage,
    canNextPage,
    pageCount,
  } = props
  return (
    <div class="flex items-center justify-between py-2">
      <PaginationSelect
        pagination={pagination}
        handlePageSizeChange={handlePageSizeChange}
      />
      <PaginationButtons
        pagination={pagination}
        pageCount={pageCount}
        canPreviousPage={canPreviousPage}
        canNextPage={canNextPage}
        handlePreviousPage={handlePreviousPage}
        handleNextPage={handleNextPage}
      />
    </div>
  )
}
