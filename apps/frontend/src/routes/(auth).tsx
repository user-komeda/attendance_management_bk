import { RouteSectionProps, useLocation, useParams } from '@solidjs/router'
import { clientOnly } from '@solidjs/start'
import {
  List,
  Tags,
  Image,
  MessageSquare,
  User,
  Users,
  KeyRound,
} from 'lucide-solid'
import { JSX, Show } from 'solid-js'

import { Item, SideMenuWrap } from '~/components/sideMenu/SideMenuWrap'
import { Flex } from '~/components/ui/flex'
import { UserIdProvider } from '~/provider/userIdProvider'
import { WorkspaceDetailProvider } from '~/provider/workspacesDetailProvider'
import { useWorkspace, WorkspaceProvider } from '~/provider/workspacesProvider'
import { buildSideIconItems } from '~/util/sideMenuItems'

export const sideMenuItems: Item[] = [
  {
    title: 'コンテンツ（API）',
    text: 'ブログ',
    icon: List,
    href: '/apis/blogs',
  },
  {
    text: 'カテゴリ',
    icon: Tags,
    href: '/apis/categories',
  },
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

const RequireAuth = clientOnly(() => import('~/components/RequireAuth'), {})

interface AuthLayoutContentProps {
  children: JSX.Element
}

const AuthLayoutContent = (props: AuthLayoutContentProps) => {
  const location = useLocation()
  const { workspaces } = useWorkspace()

  return (
    <Flex flexDirection="row" class="h-[calc(100dvh-48px)] w-full items-start">
      <aside class="h-full min-w-[10%]">
        <Flex
          flexDirection="row"
          justifyContent="start"
          alignItems="stretch"
          class="h-full"
        >
          <SideMenuWrap
            items={() => buildSideIconItems(() => workspaces()?.data)}
            isTooltip={true}
          />
          <Show when={location.pathname !== '/'}>
            <SideMenuWrap items={() => sideMenuItems} isTooltip={false} />
          </Show>
        </Flex>
      </aside>
      <div class="mx-8 w-[90%] overflow-hidden">
        <main>{props.children}</main>
      </div>
    </Flex>
  )
}

export default function AuthLayout(props: RouteSectionProps) {
  const params = useParams()
  return (
    <>
      <UserIdProvider>
        <RequireAuth>
          <WorkspaceProvider>
            <WorkspaceDetailProvider slug={params.slug}>
              {/*<ContentApiProvider>*/}
              <AuthLayoutContent>{props.children}</AuthLayoutContent>
            </WorkspaceDetailProvider>
            {/*</ContentApiProvider>*/}
          </WorkspaceProvider>
        </RequireAuth>
      </UserIdProvider>
    </>
  )
}
