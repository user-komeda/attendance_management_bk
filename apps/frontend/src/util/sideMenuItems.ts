import {
  AppWindow,
  Box,
  Image,
  List,
  MessageSquare,
  Settings,
  User,
  Users,
} from 'lucide-solid'

import type { Accessor } from 'solid-js'
import type {
  ListWorkSpacesResponse,
  WorkSpaceWithMemberShips,
} from '~/schema/api/workSpaces'

import { getWorkspaceColor } from '~/util/getColor'
import { ApiContentMenuItem, Item } from '~/util/types/SideMenuTypes'

const fixedSideIconItems: Item[] = [
  {
    text: '設定',
    icon: Settings,
    href: '/settings',
  },
]

const buildApiContentMenuItems = (
  workspaceDetail: WorkSpaceWithMemberShips,
): ApiContentMenuItem[] => {
  const slug = workspaceDetail.workSpaces.slug

  return workspaceDetail.contentApis.map((contentApi) => ({
    text: contentApi.name,
    href: `/workspaces/${slug}/apis/${contentApi.name}`,
    apiType: contentApi.apiType,
  }))
}

const getMemberCountText = (workspaceDetail: WorkSpaceWithMemberShips) => {
  return `${workspaceDetail.memberShips.length}人のメンバー`
}

const getRoleCountText = (workspaceDetail: WorkSpaceWithMemberShips) => {
  const roles = new Set(
    workspaceDetail.memberShips.map((memberShip) => memberShip.role),
  )

  return `${roles.size}個のロール`
}

const buildFixedSideMenuItems = (
  workspaceDetail: WorkSpaceWithMemberShips,
): Item[] => [
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
    text: getMemberCountText(workspaceDetail),
    icon: User,
    href: '/members',
  },
  {
    text: getRoleCountText(workspaceDetail),
    icon: Users,
    href: '/roles',
  },
]

export const buildSideMenuItems = (
  workspaceDetail: WorkSpaceWithMemberShips,
): Item[] => {
  const apiContentItems = buildApiContentMenuItems(workspaceDetail)

  return [
    {
      title: 'コンテンツ（API）',
      titleOnly: true,
    },
    ...apiContentItems.map((item) => ({
      text: item.text,
      icon: item.apiType === 'object' ? Box : List,
      href: item.href,
    })),
    ...buildFixedSideMenuItems(workspaceDetail),
  ]
}

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
