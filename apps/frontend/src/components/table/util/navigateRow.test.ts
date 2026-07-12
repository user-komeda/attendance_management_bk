import { describe, it, expect, vi } from 'vitest'

import { navigateRow } from '~/components/table/util/navigateRow'

describe('navigateRow', () => {
  it('hrefがある場合はnavigateを呼ぶこと', () => {
    const navigate = vi.fn()

    navigateRow(navigate, () => '/contentApi/workspace-1')

    expect(navigate).toHaveBeenCalledWith('/contentApi/workspace-1')
  })

  it('hrefがundefinedの場合はnavigateを呼ばないこと', () => {
    const navigate = vi.fn()

    navigateRow(navigate, () => undefined)

    expect(navigate).not.toHaveBeenCalled()
  })

  it('hrefが空文字の場合はnavigateを呼ばないこと', () => {
    const navigate = vi.fn()

    navigateRow(navigate, () => '')

    expect(navigate).not.toHaveBeenCalled()
  })
})
