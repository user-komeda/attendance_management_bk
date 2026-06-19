import { useSubmission } from '@solidjs/router'
import { createEffect, createSignal } from 'solid-js'

import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'
import { CreateWorkspaceSchema } from '~/schema/createWorkspaceSchema'
import actionWrapper from '~/util/actionWrapper'

const action = actionWrapper<typeof CreateWorkspaceSchema>(
  '/api/workspaces',
  'workspaces',
  CreateWorkspaceSchema,
)

export const useCreateWorkspace = () => {
  const { fetchWorkspaces } = useHomeWorkspaces()

  const submission = useSubmission(action)
  const [isOpen, setIsOpen] = createSignal(false)

  createEffect(() => {
    if (submission.result?.ok !== true) {
      return
    }

    setIsOpen(false)
    void fetchWorkspaces()
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
    handleOpen,
    handleClose,
  }
}
