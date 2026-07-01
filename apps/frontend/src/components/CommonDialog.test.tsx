import { fireEvent, render, screen } from '@solidjs/testing-library'
import { createSignal, type JSX } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { CommonDialog } from '~/components/CommonDialog'

vi.mock('~/components/ui/dialog', () => ({
  Dialog: (props: {
    open: boolean
    onOpenChange: (v: boolean) => void
    children: JSX.Element
  }) => (
    <div>
      <button
        type="button"
        onClick={() => {
          props.onOpenChange(false)
        }}
      >
        close dialog
      </button>
      {props.open ? props.children : null}
    </div>
  ),
  DialogContent: (props: { children: JSX.Element }) => (
    <div data-testid="dialog-content">{props.children}</div>
  ),
  DialogHeader: (props: { children: JSX.Element }) => (
    <div data-testid="dialog-header">{props.children}</div>
  ),
  DialogTitle: (props: { children: JSX.Element }) => (
    <div data-testid="dialog-title">{props.children}</div>
  ),
  DialogDescription: (props: { children: JSX.Element }) => (
    <div data-testid="dialog-description">{props.children}</div>
  ),
  DialogFooter: (props: { children: JSX.Element }) => (
    <div data-testid="dialog-footer">{props.children}</div>
  ),
}))

 
describe('CommonDialog', () => {
  it('openがtrueのときコンテンツを表示すること', () => {
    const [open, setOpen] = createSignal(true)

    render(() => (
      <CommonDialog
        open={open}
        onOpenChange={setOpen}
        title={<span>タイトル</span>}
        description={<span>説明</span>}
        footer={<button>OK</button>}
      >
        <p>コンテンツ</p>
      </CommonDialog>
    ))

    expect(screen.getByText('タイトル')).toBeInTheDocument()
    expect(screen.getByText('説明')).toBeInTheDocument()
    expect(screen.getByText('コンテンツ')).toBeInTheDocument()
    expect(screen.getByText('OK')).toBeInTheDocument()
  })

  it('openがfalseのときコンテンツを表示しないこと', () => {
    const [open, setOpen] = createSignal(false)

    render(() => (
      <CommonDialog
        open={open}
        onOpenChange={setOpen}
        title={<span>タイトル</span>}
      >
        <p>コンテンツ</p>
      </CommonDialog>
    ))

    expect(screen.queryByText('タイトル')).not.toBeInTheDocument()
    expect(screen.queryByText('コンテンツ')).not.toBeInTheDocument()
  })

  it('footerがない場合はDialogFooterを表示しないこと', () => {
    const [open, setOpen] = createSignal(true)

    render(() => (
      <CommonDialog
        open={open}
        onOpenChange={setOpen}
        title={<span>タイトル</span>}
      >
        <p>コンテンツ</p>
      </CommonDialog>
    ))

    expect(screen.queryByTestId('dialog-footer')).not.toBeInTheDocument()
  })

  it('DialogからonOpenChangeが呼ばれたときopenを更新すること', () => {
    const [open, setOpen] = createSignal(true)

    render(() => (
      <CommonDialog
        open={open}
        onOpenChange={setOpen}
        title={<span>タイトル</span>}
      >
        <p>コンテンツ</p>
      </CommonDialog>
    ))

    fireEvent.click(screen.getByRole('button', { name: 'close dialog' }))

    expect(open()).toBe(false)
  })
})
