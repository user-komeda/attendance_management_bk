import { RouteSectionProps } from '@solidjs/router'
import { clientOnly } from '@solidjs/start'

import { UserIdProvider } from '~/provider/userIdProvider'

const RequireAuth = clientOnly(() => import('~/components/RequireAuth'), {})
export default function AuthLayout(props: RouteSectionProps) {
  return (
    <>
      <UserIdProvider>
        <RequireAuth>
          <main class="container mx-auto min-h-[calc(100vh-2.5rem)] pt-16">
            {props.children}
          </main>{' '}
        </RequireAuth>
      </UserIdProvider>
    </>
  )
}
