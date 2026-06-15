import { ParentComponent, Show } from 'solid-js'

import useRedirectAuth from '~/hooks/useRedirectAuth'

const RequireAuth: ParentComponent = (props) => {
  const { isLoading, isAuthenticated } = useRedirectAuth()

  return (
    <Show when={!isLoading() && isAuthenticated()} fallback={<p>Loading...</p>}>
      {props.children}
    </Show>
  )
}

export default RequireAuth
