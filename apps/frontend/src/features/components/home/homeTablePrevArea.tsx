import { Show } from 'solid-js'

import { CommonDialog } from '~/components/CommonDialog'
import { FormInputText } from '~/components/formInputText'
import { Button } from '~/components/ui/button'
import { HomeTableSearchArea } from '~/features/components/home/homeTableSearchArea'
import { useCreateWorkspace } from '~/hooks/home/useCreateWorkspace'
import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'
import { findActionMessage } from '~/util/error'

export type SearchWorkspaces = ReturnType<typeof useSearchWorkspaces>
export type CreateWorkspace = ReturnType<typeof useCreateWorkspace>

const WorkspaceCreateActionArea = (
  props: Pick<CreateWorkspace, 'submission' | 'handleClose'> & {
    formId: string
  },
) => {
  const { submission, handleClose, formId } = props
  return (
    <div class="mt-6 flex justify-end gap-2">
      <Button
        type="button"
        variant="outline"
        onClick={handleClose}
        disabled={submission.pending}
      >
        キャンセル
      </Button>

      <Button type="submit" form={formId} disabled={submission.pending}>
        {submission.pending ? '追加中...' : '追加'}
      </Button>
    </div>
  )
}

const Content = (props: Pick<CreateWorkspace, 'submission'>) => {
  const { submission } = props
  return (
    <div class="space-y-4">
      <div>
        <FormInputText
          name={'name'}
          label={'ワークスペース名'}
          result={submission.result}
        />
      </div>

      <div>
        <FormInputText
          name={'slug'}
          label={'ワークスペースID'}
          result={submission.result}
        />
      </div>

      <p class="text-muted-foreground text-xs">
        サービスIDは英小文字・数字・ハイフンのみ使用できます。
      </p>

      <Show when={findActionMessage(submission.result)}>
        {(message) => <p class="text-destructive text-sm">{message()}</p>}
      </Show>
    </div>
  )
}

// eslint-disable-next-line max-lines-per-function
export const HomeTableHeader = () => {
  const { keyword, setKeyword, isSearching, handleSearch } =
    useSearchWorkspaces()
  const { action, submission, isOpen, setIsOpen, handleOpen, handleClose } =
    useCreateWorkspace()
  const createWorkspaceFormId = 'create-workspace-form'

  return (
    <>
      <div class="flex items-center justify-between gap-2 py-4">
        <HomeTableSearchArea
          keyword={keyword}
          setKeyword={setKeyword}
          isSearching={isSearching}
          handleSearch={handleSearch}
        />
        <Button onClick={handleOpen}>追加</Button>
      </div>

      <CommonDialog
        open={isOpen}
        onOpenChange={setIsOpen}
        title={<h2>ワークスペース追加</h2>}
        description={<p>新しいワークスペースを作成します。</p>}
        footer={
          <WorkspaceCreateActionArea
            formId={createWorkspaceFormId}
            submission={submission}
            handleClose={() => {
              submission.clear()
              handleClose()
            }}
          />
        }
      >
        <form id={createWorkspaceFormId} action={action} method="post">
          <Content submission={submission} />
        </form>
      </CommonDialog>
    </>
  )
}
