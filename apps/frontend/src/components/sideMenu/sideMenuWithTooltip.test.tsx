import { render, screen } from '@solidjs/testing-library'
import { User } from 'lucide-solid'
import { describe, expect, it, vi } from 'vitest'

import { SideMenuWithTooltip } from '~/components/sideMenu/sideMenuWithTooltip'

vi.mock('~/components/ui/button', () => ({
  buttonVariants: () => 'button-class',
}))

vi.mock('~/components/ui/tooltip', () => ({
  Tooltip: (props: { children: import('solid-js').JSX.Element }) => (
    <div>{props.children}</div>
  ),
  TooltipTrigger: (props: {
    children: import('solid-js').JSX.Element
    href?: string
    class?: string
  }) => (
    <a href={props.href} class={props.class}>
      {props.children}
    </a>
  ),
  TooltipContent: (props: { children: import('solid-js').JSX.Element }) => (
    <div>{props.children}</div>
  ),
}))

describe('SideMenuWithTooltip', () => {
  it('必須propsがある場合はツールチップ付きメニューを表示すること', () => {
    const { container } = render(() => (
      <SideMenuWithTooltip
        text="ユーザー"
        icon={User}
        href="/users"
        color="text-blue-500"
      />
    ))

    expect(screen.getAllByText('ユーザー')).toHaveLength(2)
    const link = container.querySelector('a')
    expect(link).not.toBeNull()
    expect(link).toHaveAttribute('href', '/users')
  })

  it('必須propsが不足している場合は何も表示しないこと', () => {
    const { container } = render(() => (
      <SideMenuWithTooltip text="ユーザー" icon={undefined} href="/users" />
    ))

    expect(container.firstChild).toBeNull()
  })
})
