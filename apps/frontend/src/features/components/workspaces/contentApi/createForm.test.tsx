import { fireEvent, render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { CreateForm } from '~/features/components/workspaces/contentApi/createForm'

const mockUseCreateContentApi = vi.hoisted(() => vi.fn())

vi.mock('~/hooks/contentApi/useCreateContentApi', () => ({
  useCreateContentApi: mockUseCreateContentApi,
}))

vi.mock('~/features/components/workspaces/contentApi/basicInfo', () => ({
  BasicInfo: () => <div data-testid="basic-info" />,
}))

vi.mock('~/features/components/workspaces/contentApi/typeSelect', () => ({
  TypeSelect: () => <div data-testid="type-select" />,
}))

vi.mock('~/features/components/workspaces/contentApi/schemaConfig', () => ({
  SchemaConfig: () => <div data-testid="schema-config" />,
}))

vi.mock('~/components/ui/button', () => ({
  Button: (props: {
    children: unknown
    onClick?: () => void
    type?: string
    disabled?: boolean
  }) => (
    <button
      type={props.type ?? 'button'}
      onClick={props.onClick}
      disabled={props.disabled}
    >
      {props.children}
    </button>
  ),
}))

vi.mock('~/components/ui/flex', () => ({
  Flex: (props: { children: unknown }) => <div>{props.children}</div>,
}))

const mockAction = {} as never

describe('CreateForm', () => {
  it('basicステップでBasicInfoを表示すること', () => {
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'basic',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)

    expect(screen.getByTestId('basic-info')).toBeInTheDocument()
  })

  it('typeステップでTypeSelectを表示すること', () => {
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'type',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)

    expect(screen.getByTestId('type-select')).toBeInTheDocument()
  })

  it('schemaステップでSchemaConfigを表示すること', () => {
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'schema',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)

    expect(screen.getByTestId('schema-config')).toBeInTheDocument()
  })

  it('submission.pendingがtrueの場合は作成中ボタンを表示すること', () => {
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'schema',
      submission: { pending: true },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)

    expect(screen.getByText('作成中...')).toBeInTheDocument()
  })

  it('submission.pendingがfalseの場合は作成ボタンを表示すること', () => {
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'schema',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)

    expect(screen.getByText('作成')).toBeInTheDocument()
  })

  it('basicステップで次へボタンをクリックするとhandleNextが呼ばれること', () => {
    const handleNext = vi.fn()
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'basic',
      submission: { pending: false },
      result: () => undefined,
      handleNext,
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)
    fireEvent.click(screen.getAllByText('次へ')[0])

    expect(handleNext).toHaveBeenCalledWith('basic', 'type', expect.anything())
  })

  it('typeステップで次へボタンをクリックするとhandleNextが呼ばれること', () => {
    const handleNext = vi.fn()
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'type',
      submission: { pending: false },
      result: () => undefined,
      handleNext,
      handleBack: vi.fn(),
    })

    render(() => <CreateForm action={mockAction} />)
    fireEvent.click(screen.getAllByText('次へ')[1])

    expect(handleNext).toHaveBeenCalledWith('type', 'schema', expect.anything())
  })

  it('typeステップで戻るボタンをクリックするとhandleBackが呼ばれること', () => {
    const handleBack = vi.fn()
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'type',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack,
    })

    render(() => <CreateForm action={mockAction} />)
    fireEvent.click(screen.getAllByText('戻る')[0])

    expect(handleBack).toHaveBeenCalledWith('basic')
  })

  it('schemaステップで戻るボタンをクリックするとhandleBackが呼ばれること', () => {
    const handleBack = vi.fn()
    mockUseCreateContentApi.mockReturnValue({
      step: () => 'schema',
      submission: { pending: false },
      result: () => undefined,
      handleNext: vi.fn(),
      handleBack,
    })

    render(() => <CreateForm action={mockAction} />)
    fireEvent.click(screen.getAllByText('戻る')[1])

    expect(handleBack).toHaveBeenCalledWith('type')
  })
})
