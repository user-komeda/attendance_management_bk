import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import Page from '~/routes/(auth)/workspaces/[slug]/index'

vi.mock('~/features/pages/workspaces/workspaceDetail', () => ({
  WorkspaceDetail: () => <div>Workspace Detail</div>,
}))

describe('[slug]/index', () => {
  it('renders WorkspaceDetail', () => {
    render(() => <Page />)
    expect(screen.getByText('Workspace Detail')).toBeInTheDocument()
  })
})
