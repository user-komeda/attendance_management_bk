import { fireEvent, render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import type { JSX } from 'solid-js'

import { SchemaConfig } from '~/features/components/workspaces/contentApi/schemaConfig'

vi.mock('~/components/ui/card', () => ({
  Card: (props: { children: JSX.Element }) => <div>{props.children}</div>,
  CardContent: (props: { children: JSX.Element }) => (
    <div>{props.children}</div>
  ),
}))

vi.mock('~/components/ui/text-field', () => ({
  TextField: (props: { children: JSX.Element }) => <div>{props.children}</div>,
  TextFieldLabel: (props: { children: JSX.Element; for?: string }) => (
    <label for={props.for}>{props.children}</label>
  ),
  TextFieldInput: (props: { id?: string; name?: string; type?: string }) => (
    <input
      data-testid={`input-${props.name}`}
      id={props.id}
      name={props.name}
      type={props.type}
    />
  ),
  TextFieldErrorMessage: (props: { children: JSX.Element }) => (
    <span data-testid="error">{props.children}</span>
  ),
}))

vi.mock('~/components/ui/select', () => ({
  Select: (props: {
    children: JSX.Element
    itemComponent?: (p: {
      item: { rawValue: { label: string } }
    }) => JSX.Element
  }) => {
    props.itemComponent?.({ item: { rawValue: { label: 'テキスト' } } })
    return <div>{props.children}</div>
  },
  SelectContent: () => <div />,
  SelectHiddenSelect: () => <select />,
  SelectItem: (props: { children: JSX.Element }) => <div>{props.children}</div>,
  SelectTrigger: (props: { children: JSX.Element }) => (
    <div>{props.children}</div>
  ),
  SelectValue: (props: {
    children: (state: {
      selectedOption: () => { label: string } | undefined
    }) => string | JSX.Element
  }) => (
    <div>
      {props.children({ selectedOption: () => ({ label: 'テキスト' }) })}
      {props.children({ selectedOption: () => undefined })}
    </div>
  ),
}))

vi.mock('~/components/ui/switch', () => ({
  Switch: (props: { children: JSX.Element; name?: string; value?: string }) => (
    <div data-testid={`switch-${props.name}`} data-value={props.value}>
      {props.children}
    </div>
  ),
  SwitchControl: (props: { children: JSX.Element }) => (
    <div>{props.children}</div>
  ),
  SwitchThumb: () => <span>thumb</span>,
}))

vi.mock('lucide-solid', () => ({
  GripVertical: () => <span>grip</span>,
  Plus: () => <span>plus</span>,
  Settings: () => <span>settings</span>,
  X: () => <span>x</span>,
}))

describe('SchemaConfig', () => {
  it('フィールド入力フォームを表示すること', () => {
    render(() => <SchemaConfig result={() => undefined} />)

    expect(screen.getByTestId('input-fields[0][fieldId]')).toBeInTheDocument()
    expect(
      screen.getByTestId('input-fields[0][displayName]'),
    ).toBeInTheDocument()
  })

  it('エラーメッセージがある場合は表示すること', () => {
    render(() => (
      <SchemaConfig
        result={() => ({
          ok: false,
          fieldErrors: [],
          message: 'エラーが発生しました',
        })}
      />
    ))

    expect(screen.getByText('エラーが発生しました')).toBeInTheDocument()
  })

  it('エラーがない場合はエラーメッセージを表示しないこと', () => {
    render(() => <SchemaConfig result={() => undefined} />)

    expect(screen.queryByText('エラーが発生しました')).not.toBeInTheDocument()
  })

  it('フィールド追加と削除ができること', () => {
    render(() => <SchemaConfig result={() => undefined} />)

    expect(screen.getAllByText('削除')).toHaveLength(1)

    fireEvent.click(screen.getByText('フィールドを追加'))

    expect(screen.getAllByText('削除')).toHaveLength(2)

    const removeButtons = screen.getAllByText('削除')
    fireEvent.click(removeButtons[0])

    expect(screen.getAllByText('削除')).toHaveLength(1)
  })
})
