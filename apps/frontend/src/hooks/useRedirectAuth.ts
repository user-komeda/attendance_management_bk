import { useNavigate } from '@solidjs/router'
import { createEffect, createResource } from 'solid-js'

import bffFetchWrapper from '~/util/bffFetchWrapper'

interface AuthState {
  authenticated: boolean
}

const fetchAuthState = async () => {
  const result = await bffFetchWrapper<AuthState>('/api/auth/me', 'GET')

  if (!result.ok) {
    return {
      authenticated: false,
    }
  }

  return (
    result.data ?? {
      authenticated: false,
    }
  )
}

const useRequireAuth = () => {
  const navigate = useNavigate()
  const [auth] = createResource(fetchAuthState)

  createEffect(() => {
    if (auth.loading) {
      return
    }

    if (!auth()?.authenticated) {
      navigate('/signin', { replace: true })
    }
  })

  return {
    isLoading: () => auth.loading,
    isAuthenticated: () => auth()?.authenticated ?? false,
  }
}

export default useRequireAuth
