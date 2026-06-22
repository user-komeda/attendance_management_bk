import type { Accessor, JSX, Setter } from 'solid-js'

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '~/components/ui/dialog'

interface CommonDialogProps {
  open: Accessor<boolean>
  onOpenChange: Setter<boolean>
  title: JSX.Element
  description?: JSX.Element
  children: JSX.Element
  footer?: JSX.Element
}

export const CommonDialog = (props: CommonDialogProps) => {
  return (
    <Dialog open={props.open()} onOpenChange={props.onOpenChange}>
      <DialogContent animation={'none'}>
        <DialogHeader>
          <DialogTitle>{props.title}</DialogTitle>
          <DialogDescription>{props.description}</DialogDescription>
        </DialogHeader>

        {props.children}

        {props.footer && <DialogFooter>{props.footer}</DialogFooter>}
      </DialogContent>
    </Dialog>
  )
}
