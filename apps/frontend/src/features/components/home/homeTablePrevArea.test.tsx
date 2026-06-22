import { type Submission } from '@solidjs/router'
import { render, screen, fireEvent } from '@solidjs/testing-library'
import { type JSX } from 'solid-js'
import { describe, it, expect, vi, beforeEach } from 'vitest'

import { HomeTableHeader } from '~/features/components/home/homeTablePrevArea'
import * as useCreateWorkspaceHook from '~/hooks/home/useCreateWorkspace'
import * as useSearchWorkspacesHook from '~/hooks/home/useSearchWorkspaces'
import { CreateWorkspaceSchema } from '~/schema/createWorkspaceSchema'
import { ActionResultOf, FormDataActionOf } from '~/types/action'

vi.mock('~/hooks/home/useSearchWorkspaces')
vi.mock('~/hooks/home/useCreateWorkspace')
vi.mock('~/components/CommonDialog', () => ({
  CommonDialog: (props: {
    open: () => boolean
    title: JSX.Element
    description: JSX.Element
    children: JSX.Element
    footer: JSX.Element
  }) => (
    <div>
      {props.open() && (
        <div>
          {props.title}
          {props.description}
          {props.children}
          {props.footer}
        </div>
      )}
    </div>
  ),
}))

// eslint-disable-next-line max-lines-per-function
describe('HomeTableHeader', () => {
  const mockSetKeyword = vi.fn()
  const mockHandleSearch = vi.fn()
  const mockHandleOpen = vi.fn()
  const mockHandleClose = vi.fn()

  const setupHooks = ({
    keyword = '',
    isSearching = false,
    isOpen = false,
    submissionResult = undefined,
    submissionPending = false,
  }: {
    keyword?: string
    isSearching?: boolean
    isOpen?: boolean
    submissionResult?: unknown
    submissionPending?: boolean
  } = {}) => {
    vi.mocked(useSearchWorkspacesHook.useSearchWorkspaces).mockReturnValue({
      keyword: () => keyword,
      setKeyword: mockSetKeyword,
      isSearching: () => isSearching,
      handleSearch: mockHandleSearch,
    })

    vi.mocked(useCreateWorkspaceHook.useCreateWorkspace).mockReturnValue({
      action: '/api/workspaces' as unknown as FormDataActionOf<
        typeof CreateWorkspaceSchema
      >,
      submission: {
        result: submissionResult,
        pending: submissionPending,
        clear: vi.fn(),
      } as unknown as Submission<
        [formData: FormData],
        ActionResultOf<typeof CreateWorkspaceSchema>
      >,
      isOpen: () => isOpen,
      setIsOpen: vi.fn(),
      handleOpen: mockHandleOpen,
      handleClose: mockHandleClose,
    })
  }

  beforeEach(() => {
    vi.clearAllMocks()
    setupHooks()
  })

  it('検索キーワードを表示すること', () => {
    setupHooks({ keyword: 'test-query' })

    render(() => <HomeTableHeader />)

    expect(screen.getByDisplayValue('test-query')).toBeInTheDocument()
  })

  it('検索キーワードを変更したときsetKeywordを呼ぶこと', () => {
    render(() => <HomeTableHeader />)

    const input = screen.getByPlaceholderText('ワークスペースを検索...')
    fireEvent.input(input, { target: { value: 'test-query' } })

    expect(mockSetKeyword).toHaveBeenCalledWith('test-query')
  })

  it('検索ボタンをクリックしたときhandleSearchを呼ぶこと', () => {
    render(() => <HomeTableHeader />)

    fireEvent.click(screen.getByRole('button', { name: '検索' }))

    expect(mockHandleSearch).toHaveBeenCalled()
  })

  it('検索中の場合は検索ボタンをdisabledにし、検索中表示にすること', () => {
    setupHooks({ isSearching: true })

    render(() => <HomeTableHeader />)

    const searchButton = screen.getByRole('button', { name: '検索中...' })
    expect(searchButton).toBeInTheDocument()
    expect(searchButton).toBeDisabled()
  })

  it('追加ボタンをクリックしたときhandleOpenを呼ぶこと', () => {
    render(() => <HomeTableHeader />)

    fireEvent.click(screen.getByRole('button', { name: '追加' }))

    expect(mockHandleOpen).toHaveBeenCalled()
  })

  it('isOpenがtrueの場合はワークスペース追加モーダルを表示すること', () => {
    setupHooks({ isOpen: true })

    render(() => <HomeTableHeader />)

    expect(screen.getByText('ワークスペース追加')).toBeInTheDocument()
    expect(
      screen.getByText('新しいワークスペースを作成します。'),
    ).toBeInTheDocument()
    expect(screen.getByText('ワークスペース名')).toBeInTheDocument()
    expect(screen.getByText('ワークスペースID')).toBeInTheDocument()
  })

  it('キャンセルボタンをクリックしたときhandleCloseを呼ぶこと', () => {
    setupHooks({ isOpen: true })

    render(() => <HomeTableHeader />)

    fireEvent.click(screen.getByRole('button', { name: 'キャンセル' }))

    expect(mockHandleClose).toHaveBeenCalled()
  })

  it('submission resultにfieldErrorsがある場合はフィールドエラーを表示すること', () => {
    setupHooks({
      isOpen: true,
      submissionResult: {
        ok: false,
        fieldErrors: [
          { key: 'name', message: 'Name is required' },
          { key: 'slug', message: 'Slug is invalid' },
        ],
      },
    })

    render(() => <HomeTableHeader />)

    expect(screen.getByText('Name is required')).toBeInTheDocument()
    expect(screen.getByText('Slug is invalid')).toBeInTheDocument()
  })

  it('submission resultにmessageがある場合は共通エラーを表示すること', () => {
    setupHooks({
      isOpen: true,
      submissionResult: {
        ok: false,
        message: 'General server error',
      },
    })

    render(() => <HomeTableHeader />)

    expect(screen.getByText('General server error')).toBeInTheDocument()
  })

  it('submission pendingの場合は追加中表示にし、操作ボタンをdisabledにすること', () => {
    setupHooks({
      isOpen: true,
      submissionPending: true,
    })

    render(() => <HomeTableHeader />)

    expect(screen.getByRole('button', { name: '追加中...' })).toBeDisabled()
    expect(screen.getByRole('button', { name: 'キャンセル' })).toBeDisabled()
  })
})
