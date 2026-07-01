import { Accessor } from 'solid-js'
import { describe, it, expect, vi } from 'vitest'

import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import { buildSideMenuItems, buildSideIconItems } from '~/util/sideMenuItems'

vi.mock('~/util/workspaceColor', () => ({
  getWorkspaceColor: vi.fn((slug: string) => `color-${slug}`),
}))

describe('buildSideMenuItems', () => {
  it('apiContentItemsをsideMenuItemsに変換すること', () => {
    const items = buildSideMenuItems([
      { text: 'Item1', href: '/item1' },
      { text: 'Item2', href: '/item2' },
    ])

    expect(items[0].title).toBe('APIコンテンツ')
    expect(items[0].text).toBe('Item1')
    expect(items[0].href).toBe('/item1')
    expect(items[1].title).toBeUndefined()
    expect(items[1].text).toBe('Item2')
  })

  it('apiContentItemsが空の場合はfixedSideMenuItemsのみ返すこと', () => {
    const items = buildSideMenuItems([])
    expect(items.length).toBeGreaterThan(0)
    expect(items[0].href).toBe('/media')
  })
})

describe('buildSideIconItems', () => {
  it('workspacesがある場合はworkspaceItemsとfixedSideIconItemsを返すこと', () => {
    const workspaces: Accessor<ListWorkSpacesResponse['data']> = () => [
      { id: 'aaa', name: 'WS1', slug: 'ws1', status: 'active' },
      { id: 'bbb', name: 'WS2', slug: 'ws2', status: 'active' },
    ]

    const items = buildSideIconItems(workspaces)

    expect(items[0].text).toBe('WS1')
    expect(items[0].href).toBe('/workspaces/ws1')
    expect(items[0].color).toBe('color-ws1')
    expect(items[1].text).toBe('WS2')
  })

  it('workspacesがundefinedの場合はfixedSideIconItemsのみ返すこと', () => {
    const workspaces = () => undefined

    const items = buildSideIconItems(workspaces)

    expect(items[0].text).toBe('ワークスペース追加')
  })

  it('workspacesが空配列の場合はfixedSideIconItemsのみ返すこと', () => {
    const workspaces = () => []

    const items = buildSideIconItems(workspaces)

    expect(items[0].text).toBe('ワークスペース追加')
  })
})
