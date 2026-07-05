import { RouteSectionProps, useLocation, useParams } from '@solidjs/router'
import { clientOnly } from '@solidjs/start'
import { JSX, Show, createMemo } from 'solid-js'

import { SideMenuWrap } from '~/components/sideMenu/SideMenuWrap'
import { Flex } from '~/components/ui/flex'
import { UserIdProvider } from '~/provider/userIdProvider'
import {
  useWorkspaceDetail,
  WorkspaceDetailProvider,
} from '~/provider/workspacesDetailProvider'
import { useWorkspace, WorkspaceProvider } from '~/provider/workspacesProvider'
import { buildSideIconItems, buildSideMenuItems } from '~/util/sideMenuItems'

const RequireAuth = clientOnly(() => import('~/components/RequireAuth'), {})

interface AuthLayoutContentProps {
  children: JSX.Element
}

const AuthLayoutContent = (props: AuthLayoutContentProps) => {
  const location = useLocation()
  const { workspaces } = useWorkspace()
  const { workspaceDetail } = useWorkspaceDetail()

  const sideIconItems = createMemo(() =>
    buildSideIconItems(() => workspaces()?.data),
  )

  const sideMenuItems = createMemo(() => {
    const detail = workspaceDetail()

    if (detail === undefined) {
      return []
    }

    return buildSideMenuItems(detail)
  })

  return (
    <Flex flexDirection="row" class="h-[calc(100dvh-48px)] w-full items-start">
      <aside class="h-full min-w-[10%]">
        <Flex
          flexDirection="row"
          justifyContent="start"
          alignItems="stretch"
          class="h-full"
        >
          <SideMenuWrap items={sideIconItems} isTooltip={true} />

          <Show when={location.pathname !== '/' && sideMenuItems().length > 0}>
            <SideMenuWrap items={sideMenuItems} isTooltip={false} />
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
    <UserIdProvider>
      <RequireAuth>
        <WorkspaceProvider>
          <WorkspaceDetailProvider slug={params.slug}>
            <AuthLayoutContent>{props.children}</AuthLayoutContent>
          </WorkspaceDetailProvider>
        </WorkspaceProvider>
      </RequireAuth>
    </UserIdProvider>
  )
}
