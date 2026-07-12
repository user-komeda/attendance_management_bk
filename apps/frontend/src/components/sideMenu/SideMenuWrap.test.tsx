import { render, screen } from '@solidjs/testing-library'
import { Bell, Plus, User } from 'lucide-solid'
import { describe, it, expect, vi } from 'vitest'

import { SideMenuWrap, Item } from '~/components/sideMenu/SideMenuWrap'

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    A: (props: {
      href: string
      children?:
        | import('solid-js').JSX.Element
        | (() => import('solid-js').JSX.Element)
      class?: string
      activeClass?: string
    }) => (
      <a href={props.href}>
        {typeof props.children === 'function'
          ? props.children()
          : props.children}
      </a>
    ),
    useLocation: () => ({ pathname: '/' }),
  }
})

const baseItems: Item[] = [
  { text: 'Item1', icon: User, href: '/item1' },
  { text: 'Item2', icon: Bell, href: '/item2' },
]

const itemsWithSeparate: Item[] = [
  { text: 'Top1', icon: User, href: '/top1' },
  { text: 'Bottom1', icon: Bell, href: '/bottom1', separate: true },
  { text: 'Bottom2', icon: Plus, href: '/bottom2' },
]

describe('SideMenuWrap', () => {
  it('isTooltip=falseの場合SideMenuを表示すること', () => {
    render(() => <SideMenuWrap items={() => baseItems} isTooltip={false} />)
    expect(screen.getByText('Item1')).toBeInTheDocument()
    expect(screen.getByText('Item2')).toBeInTheDocument()
  })

  it('isTooltip=trueの場合SideMenuWithTooltipを表示すること', () => {
    render(() => <SideMenuWrap items={() => baseItems} isTooltip={true} />)
    expect(screen.getByText('Item1')).toBeInTheDocument()
    expect(screen.getByText('Item2')).toBeInTheDocument()
  })

  it('separateがある場合はbottomItemsを下部に表示すること', () => {
    render(() => (
      <SideMenuWrap items={() => itemsWithSeparate} isTooltip={false} />
    ))
    expect(screen.getByText('Top1')).toBeInTheDocument()
    expect(screen.getByText('Bottom1')).toBeInTheDocument()
    expect(screen.getByText('Bottom2')).toBeInTheDocument()
  })

  it('separateがない場合はbottomNavを表示しないこと', () => {
    render(() => <SideMenuWrap items={() => baseItems} isTooltip={false} />)
    const navs = screen.getAllByRole('navigation')
    expect(navs.length).toBe(1)
  })
})
