import { describe, it, expect } from 'vitest'

import { formDataToObject } from '~/util/formDataToObject'

describe('formDataToObject', () => {
  it('通常フィールドをオブジェクトに変換すること', () => {
    const formData = new FormData()
    formData.append('name', 'Taro')
    formData.append('email', 'taro@example.com')

    expect(formDataToObject(formData)).toEqual({
      name: 'Taro',
      email: 'taro@example.com',
    })
  })

  it('配列形式のキーを配列オブジェクトに変換すること', () => {
    const formData = new FormData()
    formData.append('members[0][name]', 'Alice')
    formData.append('members[0][role]', 'admin')
    formData.append('members[1][name]', 'Bob')

    expect(formDataToObject(formData)).toEqual({
      members: [{ name: 'Alice', role: 'admin' }, { name: 'Bob' }],
    })
  })

  it('通常キーと配列キーが混在しても正しく変換すること', () => {
    const formData = new FormData()
    formData.append('title', 'workspace')
    formData.append('items[2][value]', 'third')

    const result = formDataToObject(formData)

    expect(result).toMatchObject({
      title: 'workspace',
    })
    expect(result.items).toHaveLength(3)
    expect((result.items as Record<string, string>[])[2]).toEqual({
      value: 'third',
    })
  })
})
