import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import type { JSX } from 'solid-js'

import { TypeSelect } from '~/features/components/workspaces/contentApi/typeSelect'

vi.mock('~/components/ui/flex', () => ({
  Flex: (props: { children: JSX.Element }) => <div>{props.children}</div>,
}))

vi.mock('~/components/ui/radio-group', () => ({
  RadioGroup: (props: { children: JSX.Element }) => <div>{props.children}</div>,
  RadioGroupItem: (props: { children: JSX.Element; value: string }) => (
    <div data-testid={`radio-${props.value}`}>{props.children}</div>
  ),
  RadioGroupItemLabel: (props: { children: JSX.Element }) => (
    <label>{props.children}</label>
  ),
}))

describe('TypeSelect', () => {
  it('リスト形式とオブジェクト形式のラジオボタンを表示すること', () => {
    render(() => <TypeSelect result={() => undefined} />)

    expect(screen.getByTestId('radio-list')).toBeInTheDocument()
    expect(screen.getByTestId('radio-object')).toBeInTheDocument()
  })

  it('apiTypeのエラーメッセージがある場合は表示すること', () => {
    render(() => (
      <TypeSelect
        result={() => ({
          ok: false,
          fieldErrors: [{ key: 'apiType', message: '型を選択してください' }],
          message: '',
        })}
      />
    ))

    expect(screen.getByText('型を選択してください')).toBeInTheDocument()
  })

  it('actionメッセージがある場合は表示すること', () => {
    render(() => (
      <TypeSelect
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
    render(() => <TypeSelect result={() => undefined} />)

    expect(screen.queryByText('エラーが発生しました')).not.toBeInTheDocument()
  })
})
