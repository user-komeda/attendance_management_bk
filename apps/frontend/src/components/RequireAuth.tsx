import { ParentComponent, Show } from 'solid-js'

import useRedirectAuth from '~/hooks/useRedirectAuth'

const RequireAuth: ParentComponent = (props) => {
  const { isLoading } = useRedirectAuth()

  return (
    <Show when={!isLoading()} fallback={<p>Loading...</p>}>
      {props.children}
    </Show>
  )
}

export default RequireAuth
