// @refresh reload
import { mount, StartClient } from '@solidjs/start/client'

mount(() => {
  requestAnimationFrame(() => {
    document.body.setAttribute('data-hydrated', 'true')
  })
  return <StartClient />
}, document.getElementById('app')!)
