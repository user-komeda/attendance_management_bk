import { useSubmission } from '@solidjs/router'
import { createEffect, createSignal } from 'solid-js'

import { useWorkspace } from '~/provider/workspacesProvider'
import { CreateWorkspaceSchema } from '~/schema/workspace/createWorkspaceSchema'
import actionWrapper from '~/util/actionWrapper'

const action = actionWrapper<typeof CreateWorkspaceSchema>({
  path: '/api/contentApi',
  method: 'POST',
  schema: CreateWorkspaceSchema,
  name: 'createWorkspace',
})

export const useCreateWorkspace = () => {
  const { refetchWorkspaces } = useWorkspace()

  const submission = useSubmission(action)
  const [isOpen, setIsOpen] = createSignal(false)

  createEffect(() => {
    if (submission.result?.ok !== true) {
      return
    }

    setIsOpen(false)
    void refetchWorkspaces()
  })

  const handleOpen = () => {
    setIsOpen(true)
  }

  const handleClose = () => {
    if (submission.pending) {
      return
    }

    setIsOpen(false)
  }

  return {
    action,
    submission,
    isOpen,
    setIsOpen,
    handleOpen,
    handleClose,
  }
}
