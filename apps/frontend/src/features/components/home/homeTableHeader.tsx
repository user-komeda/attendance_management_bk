import { Show } from 'solid-js'

import { Button } from '~/components/ui/button'
import { TextField, TextFieldInput } from '~/components/ui/text-field'
import { useCreateWorkspace } from '~/hooks/home/useCreateWorkspace'
import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'
import { findActionMessage, findError } from '~/util/error'

export const HomeTableHeader = () => {
  const { keyword, setKeyword, isSearching, handleSearch } =
    useSearchWorkspaces()

  const { action, submission, isOpen, handleOpen, handleClose } =
    useCreateWorkspace()

  return (
    <>
      <div class="flex items-center justify-between gap-2 py-4">
        <div class="flex items-center gap-2">
          <TextField value={keyword()} onChange={setKeyword}>
            <TextFieldInput
              placeholder="ワークスペースを検索..."
              class="max-w-sm"
            />
          </TextField>

          <Button onClick={handleSearch} disabled={isSearching()}>
            {isSearching() ? '検索中...' : '検索'}
          </Button>
        </div>

        <Button onClick={handleOpen}>追加</Button>
      </div>

      <Show when={isOpen()}>
        <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div class="bg-background w-full max-w-md rounded-lg p-6 shadow-lg">
            <form action={action} method="post">
              <div class="mb-4">
                <h2 class="text-lg font-semibold">ワークスペース追加</h2>
                <p class="text-muted-foreground text-sm">
                  新しいワークスペースを作成します。
                </p>
              </div>

              <div class="space-y-4">
                <div>
                  <TextField>
                    <TextFieldInput
                      name="name"
                      placeholder="ワークスペース名"
                    />
                  </TextField>
                  <Show when={findError(submission.result, 'name')}>
                    {(message) => (
                      <p class="text-destructive mt-1 text-sm">{message()}</p>
                    )}
                  </Show>
                </div>

                <div>
                  <TextField>
                    <TextFieldInput name="slug" placeholder="サービスID" />
                  </TextField>
                  <Show when={findError(submission.result, 'slug')}>
                    {(message) => (
                      <p class="text-destructive mt-1 text-sm">{message()}</p>
                    )}
                  </Show>
                </div>

                <p class="text-muted-foreground text-xs">
                  サービスIDは英小文字・数字・ハイフンのみ使用できます。
                </p>

                <Show when={findActionMessage(submission.result)}>
                  {(message) => (
                    <p class="text-destructive text-sm">{message()}</p>
                  )}
                </Show>
              </div>

              <div class="mt-6 flex justify-end gap-2">
                <Button
                  type="button"
                  variant="outline"
                  onClick={handleClose}
                  disabled={submission.pending}
                >
                  キャンセル
                </Button>

                <Button type="submit" disabled={submission.pending}>
                  {submission.pending ? '追加中...' : '追加'}
                </Button>
              </div>
            </form>
          </div>
        </div>
      </Show>
    </>
  )
}
