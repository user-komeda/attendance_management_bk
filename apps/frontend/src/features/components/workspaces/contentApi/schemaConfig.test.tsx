import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { SchemaConfig } from '~/features/components/workspaces/contentApi/schemaConfig'

vi.mock('~/components/ui/card', () => ({
  Card: (props: { children: unknown }) => <div>{props.children}</div>,
  CardContent: (props: { children: unknown }) => <div>{props.children}</div>,
}))

vi.mock('~/components/ui/text-field', () => ({
  TextField: (props: { children: unknown }) => <div>{props.children}</div>,
  TextFieldLabel: (props: { children: unknown; for?: string }) => (
    <label htmlFor={props.for}>{props.children}</label>
  ),
  TextFieldInput: (props: { id?: string; name?: string; type?: string }) => (
    <input
      data-testid={`input-${props.name}`}
      id={props.id}
      name={props.name}
      type={props.type}
    />
  ),
  TextFieldErrorMessage: (props: { children: unknown }) => (
    <span data-testid="error">{props.children}</span>
  ),
}))

vi.mock('~/components/ui/select', () => ({
  Select: (props: {
    children: unknown
    itemComponent?: (p: { item: { rawValue: { label: string } } }) => unknown
  }) => {
    props.itemComponent?.({ item: { rawValue: { label: 'テキスト' } } })
    return <div>{props.children}</div>
  },
  SelectContent: () => <div />,
  SelectItem: (props: { children: unknown }) => <div>{props.children}</div>,
  SelectTrigger: (props: { children: unknown }) => <div>{props.children}</div>,
  SelectValue: (props: {
    children: (state: {
      selectedOption: () => { label: string } | undefined
    }) => unknown
  }) => (
    <div>
      {props.children({ selectedOption: () => ({ label: 'テキスト' }) })}
      {props.children({ selectedOption: () => undefined })}
    </div>
  ),
}))

vi.mock('~/components/ui/switch', () => ({
  Switch: () => <input type="checkbox" data-testid="switch" />,
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

    expect(screen.getByTestId('input-fieldId')).toBeInTheDocument()
    expect(screen.getByTestId('input-displayName')).toBeInTheDocument()
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
})
