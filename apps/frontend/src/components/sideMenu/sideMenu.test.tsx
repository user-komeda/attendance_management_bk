import { render, screen } from '@solidjs/testing-library'
import { Bell } from 'lucide-solid'
import { describe, it, expect, vi } from 'vitest'

import { SideMenu } from '~/components/sideMenu/sideMenu'

vi.mock('@solidjs/router', async (importOriginal) => {
  const actual = (await importOriginal()) as Record<string, unknown>
  return {
    ...actual,
    A: (props: {
      href: string
      children?: import('solid-js').JSX.Element
      class?: string
      activeClass?: string
    }) => <a href={props.href}>{props.children}</a>,
  }
})

describe('SideMenu', () => {
  it('textとhrefを表示すること', () => {
    render(() => <SideMenu text="通知" icon={Bell} href="/notifications" />)
    expect(screen.getByText('通知')).toBeInTheDocument()
    expect(screen.getByRole('link')).toHaveAttribute('href', '/notifications')
  })

  it('titleがある場合はtitleを表示すること', () => {
    render(() => (
      <SideMenu
        text="通知"
        icon={Bell}
        href="/notifications"
        title="メニュー"
      />
    ))
    expect(screen.getByText('メニュー')).toBeInTheDocument()
  })

  it('titleがない場合はtitleを表示しないこと', () => {
    render(() => <SideMenu text="通知" icon={Bell} href="/notifications" />)
    expect(screen.queryByText('メニュー')).not.toBeInTheDocument()
  })
})
