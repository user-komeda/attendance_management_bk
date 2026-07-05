import type { Component } from 'solid-js'
import type { Accessor } from 'solid-js'

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

import type { ListWorkSpacesResponse } from '~/schema/api/workSpaces'
import type { WorkSpaceWithMemberShips } from '~/schema/api/workSpaces'

export interface Item {
  title?: string
  text?: string
  icon?: Component
  href?: string
  color?: string
  titleOnly?: boolean
}

export interface ApiContentMenuItem {
  text: string
  href: string
  title?: string
  apiType: 'list' | 'object'
}

const workspaceColors = [
  'bg-red-500',
  'bg-orange-500',
  'bg-amber-500',
  'bg-yellow-500',
  'bg-lime-500',
  'bg-green-500',
  'bg-emerald-500',
  'bg-teal-500',
  'bg-cyan-500',
  'bg-sky-500',
  'bg-blue-500',
  'bg-indigo-500',
  'bg-violet-500',
  'bg-purple-500',
  'bg-fuchsia-500',
  'bg-pink-500',
  'bg-rose-500',
]

const getWorkspaceColor = (slug: string) => {
  const hash = Array.from(slug).reduce((acc, char) => {
    return acc + char.charCodeAt(0)
  }, 0)

  return workspaceColors[hash % workspaceColors.length]
}

const fixedSideIconItems: Item[] = [
  {
    text: '設定',
    icon: Settings,
    href: '/settings',
  },
]

const getApiContentIcon = (apiType: ApiContentMenuItem['apiType']) => {
  if (apiType === 'object') {
    return Box
  }

  return List
}

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
      icon: getApiContentIcon(item.apiType),
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
