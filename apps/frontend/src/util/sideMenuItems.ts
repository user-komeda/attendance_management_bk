import {
  AppWindow,
  Bell,
  Image,
  KeyRound,
  List,
  MessageSquare,
  Plus,
  RadioTower,
  User,
  UserCircle,
  Users,
} from 'lucide-solid'
import { Accessor } from 'solid-js'

import type { Item } from '~/components/sideMenu/SideMenuWrap'

import { ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import { getWorkspaceColor } from '~/util/workspaceColor'

export interface ApiContentMenuItem {
  text: string
  href: string
  title?: string
}

const fixedSideMenuItems: Item[] = [
  {
    title: 'メディア',
    text: '8件のアイテム',
    icon: Image,
    href: '/media',
  },
  {
    title: 'レビュー',
    text: '0件の申請',
    icon: MessageSquare,
    href: '/reviews',
  },
  {
    title: '権限管理',
    text: '1人のメンバー',
    icon: User,
    href: '/members',
  },
  {
    text: '1個のロール',
    icon: Users,
    href: '/roles',
  },
  {
    text: '1個のAPIキー',
    icon: KeyRound,
    href: '/api-keys',
  },
]

const fixedSideIconItems: Item[] = [
  {
    text: 'ワークスペース追加',
    icon: Plus,
    href: '/contentApi/new',
  },
  {
    separate: true,
    text: '通知',
    icon: Bell,
    href: '/notifications',
  },
  {
    text: 'アクティビティ',
    icon: RadioTower,
    href: '/activities',
  },
  {
    text: 'アカウント',
    icon: UserCircle,
    href: '/account',
    color: 'bg-blue-700 text-blue-500',
  },
]

export const buildSideMenuItems = (
  apiContentItems: ApiContentMenuItem[],
): Item[] => [
  ...apiContentItems.map((item, index) => ({
    title: index === 0 ? 'APIコンテンツ' : undefined,
    text: item.text,
    icon: List,
    href: item.href,
  })),
  ...fixedSideMenuItems,
]

export const buildSideIconItems = (
  workspaces: Accessor<ListWorkSpacesResponse['data'] | undefined>,
): Item[] => {
  return [
    ...(workspaces() ?? []).map((workspace) => ({
      text: workspace.name,
      icon: AppWindow,
      href: `/workspaces/${workspace.slug}`,
      color: getWorkspaceColor(workspace.slug),
    })),
    ...fixedSideIconItems,
  ]
}
