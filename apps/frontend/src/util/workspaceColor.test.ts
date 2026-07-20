import { describe, expect, it } from 'vitest'

import { getWorkspaceColor, workspaceIconPalette } from '~/util/workspaceColor'

describe('workspaceColor', () => {
  it('パレットが定義されていること', () => {
    expect(workspaceIconPalette.length).toBeGreaterThan(0)
  })

  it('同じキーなら同じ色を返すこと', () => {
    const key = 'workspace-slug'

    expect(getWorkspaceColor(key)).toBe(getWorkspaceColor(key))
  })

  it('返却値が常にパレット内に含まれること', () => {
    const color = getWorkspaceColor('another-slug')

    expect(workspaceIconPalette).toContain(color)
  })

  it('空文字でもパレット内の色を返すこと', () => {
    const color = getWorkspaceColor('')

    expect(workspaceIconPalette).toContain(color)
  })
})
