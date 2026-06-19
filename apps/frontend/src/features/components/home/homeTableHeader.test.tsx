import { render, screen, fireEvent } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { HomeTableHeader } from '~/features/components/home/homeTableHeader'
import { useCreateWorkspace } from '~/hooks/home/useCreateWorkspace'
import { useSearchWorkspaces } from '~/hooks/home/useSearchWorkspaces'

vi.mock('~/hooks/home/useSearchWorkspaces', () => ({
  useSearchWorkspaces: vi.fn(),
}))

vi.mock('~/hooks/home/useCreateWorkspace', () => ({
  useCreateWorkspace: vi.fn(),
}))

describe('HomeTableHeader', () => {
  it('検索キーワードの入力と検索ボタンが動作すること', () => {
    const setKeyword = vi.fn()
    const handleSearch = vi.fn()
    vi.mocked(useSearchWorkspaces).mockReturnValue({
      keyword: () => 'test',
      setKeyword,
      isSearching: () => false,
      handleSearch,
    } as unknown as ReturnType<typeof useSearchWorkspaces>)

    vi.mocked(useCreateWorkspace).mockReturnValue({
      isOpen: () => false,
      handleOpen: vi.fn(),
    } as unknown as ReturnType<typeof useCreateWorkspace>)

    render(() => <HomeTableHeader />)

    const input = screen.getByPlaceholderText('ワークスペースを検索...')
    expect(input).toHaveValue('test')

    const searchButton = screen.getByText('検索')
    fireEvent.click(searchButton)
    expect(handleSearch).toHaveBeenCalled()
  })

  it('検索中はボタンが検索中になること', () => {
    vi.mocked(useSearchWorkspaces).mockReturnValue({
      keyword: () => '',
      isSearching: () => true,
    } as unknown as ReturnType<typeof useSearchWorkspaces>)

    render(() => <HomeTableHeader />)
    expect(screen.getByText('検索中...')).toBeInTheDocument()
    expect(screen.getByText('検索中...')).toBeDisabled()
  })

  it('追加ボタンをクリックするとモーダルが開くこと', () => {
    const handleOpen = vi.fn()
    vi.mocked(useSearchWorkspaces).mockReturnValue({
      keyword: () => '',
      isSearching: () => false,
    } as unknown as ReturnType<typeof useSearchWorkspaces>)

    vi.mocked(useCreateWorkspace).mockReturnValue({
      isOpen: () => false,
      handleOpen,
    } as unknown as ReturnType<typeof useCreateWorkspace>)

    render(() => <HomeTableHeader />)
    fireEvent.click(screen.getByText('追加'))
    expect(handleOpen).toHaveBeenCalled()
  })

  it('モーダルが表示され、エラーメッセージが表示されること', () => {
    const handleClose = vi.fn()
    vi.mocked(useSearchWorkspaces).mockReturnValue({
      keyword: () => '',
      isSearching: () => false,
    } as unknown as ReturnType<typeof useSearchWorkspaces>)

    vi.mocked(useCreateWorkspace).mockReturnValue({
      isOpen: () => true,
      handleClose,
      submission: {
        result: {
          ok: false,
          fieldErrors: [
            { key: 'name', message: 'Name error' },
            { key: 'slug', message: 'Slug error' },
          ],
          message: 'Global error',
        },
        pending: false,
      },
    } as unknown as ReturnType<typeof useCreateWorkspace>)

    render(() => <HomeTableHeader />)

    expect(screen.getByText('ワークスペース追加')).toBeInTheDocument()
    expect(screen.getByText('Name error')).toBeInTheDocument()
    expect(screen.getByText('Slug error')).toBeInTheDocument()
    expect(screen.getByText('Global error')).toBeInTheDocument()

    fireEvent.click(screen.getByText('キャンセル'))
    expect(handleClose).toHaveBeenCalled()
  })

  it('送信中はボタンが「追加中...」になり無効化されること', () => {
    vi.mocked(useCreateWorkspace).mockReturnValue({
      isOpen: () => true,
      submission: {
        pending: true,
      },
    } as unknown as ReturnType<typeof useCreateWorkspace>)

    render(() => <HomeTableHeader />)
    expect(screen.getByText('追加中...')).toBeInTheDocument()
    expect(screen.getByText('追加中...')).toBeDisabled()
    expect(screen.getByText('キャンセル')).toBeDisabled()
  })
})
