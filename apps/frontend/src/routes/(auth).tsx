import { RouteSectionProps } from '@solidjs/router'
import { clientOnly } from '@solidjs/start'

const RequireAuth = clientOnly(() => import('~/components/RequireAuth'), {})
export default function AuthLayout(props: RouteSectionProps) {
  return (
    <>
      <RequireAuth>
        <main>{props.children}</main>
      </RequireAuth>
    </>
  )
}
