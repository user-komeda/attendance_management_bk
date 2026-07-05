import { Component, For, Show, createMemo, Accessor } from 'solid-js'

import { SideMenu } from '~/components/sideMenu/sideMenu'
import { SideMenuWithTooltip } from '~/components/sideMenu/sideMenuWithTooltip'
import { Flex } from '~/components/ui/flex'

export interface Item {
  text?: string
  title?: string
  icon?: Component
  href?: string
  color?: string
  titleOnly?: boolean

  /**
   * この item 以降を下側に分離する
   */
  separate?: boolean
}
interface Props {
  items: Accessor<Item[]>
  isTooltip: boolean
}

// eslint-disable-next-line max-lines-per-function
export const SideMenuWrap = (props: Props) => {
  const { items } = props
  const { isTooltip } = props

  const separateIndex = createMemo(() =>
    items().findIndex((item) => item.separate),
  )

  const topItems = createMemo(() => {
    const index = separateIndex()

    if (index === -1) {
      return items()
    }

    return items().slice(0, index)
  })

  const bottomItems = createMemo(() => {
    const index = separateIndex()

    if (index === -1) {
      return []
    }

    return items().slice(index)
  })

  const renderItem = (item: Item) => {
    return (
      <Show when={isTooltip} fallback={<SideMenu {...item} />}>
        <SideMenuWithTooltip {...item} />
      </Show>
    )
  }

  return (
    <Flex
      flexDirection="col"
      justifyContent="start"
      alignItems="stretch"
      class={`group h-full gap-4 py-4`}
    >
      <nav class="grid gap-1 px-2">
        <For each={topItems()}>{(item) => renderItem(item)}</For>
      </nav>

      <Show when={bottomItems().length > 0}>
        <nav class="mt-auto grid gap-1 px-2">
          <For each={bottomItems()}>{(item) => renderItem(item)}</For>
        </nav>
      </Show>
    </Flex>
  )
}
