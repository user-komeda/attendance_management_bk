import { Accessor } from 'solid-js'
import { describe, it, expect } from 'vitest'

import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import { buildSideMenuItems, buildSideIconItems } from '~/util/sideMenuItems'

describe('buildSideMenuItems', () => {
  it('apiContentItemsをsideMenuItemsに変換すること', () => {
    const items = buildSideMenuItems({
      workSpaces: { slug: 'ws-1' },
      memberShips: [{ role: 'admin' }, { role: 'editor' }],
      contentApis: [
        { name: 'Item1', apiType: 'list' },
        { name: 'Item2', apiType: 'object' },
      ],
    } as never)

    expect(items[0].title).toBe('コンテンツ（API）')
    expect(items[0].titleOnly).toBe(true)
    expect(items[1].text).toBe('Item1')
    expect(items[1].href).toBe('/workspaces/ws-1/apis/Item1')
    expect(items[2].text).toBe('Item2')
    expect(items[2].href).toBe('/workspaces/ws-1/apis/Item2')
  })

  it('apiContentItemsが空の場合はfixedSideMenuItemsのみ返すこと', () => {
    const items = buildSideMenuItems({
      workSpaces: { slug: 'ws-1' },
      memberShips: [],
      contentApis: [],
    } as never)

    expect(items.length).toBeGreaterThan(0)
    expect(items[0].title).toBe('コンテンツ（API）')
    expect(items[1].href).toBe('/media')
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
    expect(typeof items[0].color).toBe('string')
    expect(items[1].text).toBe('WS2')
  })

  it('workspacesがundefinedの場合はfixedSideIconItemsのみ返すこと', () => {
    const workspaces = () => undefined

    const items = buildSideIconItems(workspaces)

    expect(items[0].text).toBe('設定')
  })

  it('workspacesが空配列の場合はfixedSideIconItemsのみ返すこと', () => {
    const workspaces = () => []

    const items = buildSideIconItems(workspaces)

    expect(items[0].text).toBe('設定')
  })
})
