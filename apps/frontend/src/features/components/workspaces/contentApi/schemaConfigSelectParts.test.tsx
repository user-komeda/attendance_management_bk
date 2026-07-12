import { render, screen } from '@solidjs/testing-library'
import { describe, expect, it, vi } from 'vitest'

import type { JSX } from 'solid-js'

import { FieldTypeSelect } from '~/features/components/workspaces/contentApi/schemaConfigSelectParts'

vi.mock('~/components/ui/select', () => ({
  Select: (props: {
    children: JSX.Element
    name: string
    placeholder: string
    itemComponent?: (props: {
      item: { rawValue: { label: string } }
    }) => JSX.Element
  }) => (
    <div
      data-testid="select"
      data-name={props.name}
      data-placeholder={props.placeholder}
    >
      {props.itemComponent?.({ item: { rawValue: { label: 'テキスト' } } })}
      {props.children}
    </div>
  ),
  SelectContent: () => <div data-testid="select-content" />,
  SelectHiddenSelect: () => <div data-testid="select-hidden" />,
  SelectItem: (props: { children: JSX.Element }) => <div>{props.children}</div>,
  SelectTrigger: (props: { id: string; children: JSX.Element }) => (
    <div data-testid={props.id}>{props.children}</div>
  ),
  SelectValue: (props: {
    children: (state: {
      selectedOption: () => { label: string } | undefined
    }) => JSX.Element
  }) => (
    <div>
      {props.children({ selectedOption: () => ({ label: 'テキスト' }) })}
      {props.children({ selectedOption: () => undefined })}
    </div>
  ),
}))

describe('FieldTypeSelect', () => {
  it('セレクト要素を表示すること', () => {
    render(() => (
      <FieldTypeSelect
        id="fields-0-fieldType"
        name="fields[0][fieldType]"
        result={undefined}
      />
    ))

    expect(screen.getByText('種類')).toBeInTheDocument()
    expect(screen.getByTestId('select')).toBeInTheDocument()
    expect(screen.getByTestId('fields-0-fieldType')).toBeInTheDocument()
    expect(screen.getByTestId('select-content')).toBeInTheDocument()
    expect(screen.getByTestId('select-hidden')).toBeInTheDocument()
  })

  it('fieldTypeのエラーがある場合はメッセージを表示すること', () => {
    render(() => (
      <FieldTypeSelect
        id="fields-0-fieldType"
        name="fields[0][fieldType]"
        result={{
          ok: false,
          fieldErrors: [
            {
              key: 'fields',
              path: [{ key: 'fields' }, { key: 0 }, { key: 'fieldType' }],
              message: '種類を選択してください',
            },
          ],
          message: '',
        }}
      />
    ))

    expect(screen.getByText('種類を選択してください')).toBeInTheDocument()
  })

  it('エラーがない場合はエラーメッセージを表示しないこと', () => {
    render(() => (
      <FieldTypeSelect
        id="fields-0-fieldType"
        name="fields[0][fieldType]"
        result={{ ok: true }}
      />
    ))

    expect(screen.queryByText('種類を選択してください')).not.toBeInTheDocument()
  })
})
