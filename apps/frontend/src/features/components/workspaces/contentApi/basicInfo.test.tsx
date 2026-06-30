import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { BasicInfo } from '~/features/components/workspaces/contentApi/basicInfo'

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

describe('BasicInfo', () => {
  it('nameとendpointの入力フィールドを表示すること', () => {
    render(() => <BasicInfo result={() => undefined} />)

    expect(screen.getByTestId('input-name')).toBeInTheDocument()
    expect(screen.getByTestId('input-endpoint')).toBeInTheDocument()
  })

  it('エラーメッセージがある場合は表示すること', () => {
    render(() => (
      <BasicInfo
        result={() => ({
          ok: false,
          fieldErrors: [],
          message: 'エラーが発生しました',
        })}
      />
    ))

    expect(screen.getByText('エラーが発生しました')).toBeInTheDocument()
  })

  it('エラーメッセージがない場合は表示しないこと', () => {
    render(() => <BasicInfo result={() => undefined} />)

    expect(screen.queryByText('エラーが発生しました')).not.toBeInTheDocument()
  })
})
