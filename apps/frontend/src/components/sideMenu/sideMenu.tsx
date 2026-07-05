import { A } from '@solidjs/router'

import { Item } from '~/components/sideMenu/SideMenuWrap'
import { buttonVariants } from '~/components/ui/button'
import { cn } from '~/lib/utils'

export const SideMenu = (props: Item) => {
  const { title, text, icon: Icon, href, titleOnly } = props

  if (titleOnly) {
    return (
      <div class="space-y-1">
        {title && (
          <div class="text-muted-foreground px-3 pt-4 pb-1 text-xs font-semibold">
            {title}
          </div>
        )}
      </div>
    )
  }

  if (Icon === undefined || href === undefined || text === undefined) {
    return null
  }

  return (
    <div class="space-y-1">
      {title && (
        <div class="text-muted-foreground px-3 pt-4 pb-1 text-xs font-semibold">
          {title}
        </div>
      )}

      <A
        href={href}
        class={cn(
          buttonVariants({
            variant: 'ghost',
            size: 'sm',
            class: 'text-sm',
          }),
          'w-full justify-start gap-2',
          'text-muted-foreground hover:text-foreground',
          'dark:hover:bg-muted dark:text-muted-foreground dark:bg-transparent dark:hover:text-white',
        )}
        activeClass="bg-violet-100 text-violet-700 font-semibold hover:bg-violet-100 hover:text-violet-700"
      >
        <Icon />
        <span>{text}</span>
      </A>
    </div>
  )
}
