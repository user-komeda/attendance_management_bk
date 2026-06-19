import { describe, it, expect } from 'vitest'

import { useHomeWorkspaces } from '~/provider/homeWorkspacesProvider'

describe('homeWorkspacesProvider', () => {
  it('useHomeWorkspaces throws error when used outside provider', () => {
    expect(() => useHomeWorkspaces()).toThrow(
      'useHomeWorkspaces must be used within HomeWorkspacesContext.Provider',
    )
  })
})
