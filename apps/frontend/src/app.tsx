import { Router } from '@solidjs/router'
import { FileRoutes } from '@solidjs/start/router'
import { ErrorBoundary, Suspense } from 'solid-js'

import Nav from '~/components/Nav'
import '~/app.css'

export default function App() {
  return (
    <Router
      root={(props) => (
        <>
          <Nav />
          <ErrorBoundary
            fallback={(err) => <div>{err?.message || String(err)}</div>}
          >
            <Suspense>{props.children}</Suspense>
          </ErrorBoundary>
        </>
      )}
    >
      <FileRoutes />
    </Router>
  )
}
