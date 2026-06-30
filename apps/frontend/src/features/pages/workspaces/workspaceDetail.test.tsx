import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { WorkspaceDetail } from '~/features/pages/workspaces/workspaceDetail'

const useParamsMock = vi.hoisted(() => vi.fn(() => ({ slug: 'test-slug' })))

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    useParams: useParamsMock,
    action: vi.fn((fn: unknown) => ({ fn, with: (param: unknown) => [param] })),
  }
})

vi.mock('~/features/components/workspaces/contentApi/createForm', () => ({
  CreateForm: () => <div data-testid="create-form" />,
}))

describe('WorkspaceDetail', () => {
  it('slugがある場合はCreateFormを表示すること', () => {
    useParamsMock.mockReturnValue({ slug: 'test-slug' })
    render(() => <WorkspaceDetail />)
    expect(screen.getByTestId('create-form')).toBeInTheDocument()
  })

  it('slugがない場合はnullを返すこと', () => {
    useParamsMock.mockReturnValue({ slug: undefined as unknown as string })
    const { container } = render(() => <WorkspaceDetail />)
    expect(container.firstChild).toBeNull()
  })
})
