import { Item } from '~/components/sideMenu/SideMenuWrap'
import { buttonVariants } from '~/components/ui/button'
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '~/components/ui/tooltip'
import { cn } from '~/lib/utils'

export const SideMenuWithTooltip = (props: Item) => {
  const { text, icon: Icon, href, color } = props

  return (
    <Tooltip openDelay={0} closeDelay={0} placement="right">
      <TooltipTrigger
        as="a"
        href={href}
        class={cn(
          buttonVariants({ size: 'icon' }),
          'size-9',
          'rounded-full',
          'text-muted-foreground bg-transparent',
          'hover:bg-muted hover:text-white',
          'dark:text-muted-foreground dark:hover:bg-muted dark:bg-transparent dark:hover:text-white',
          color,
        )}
      >
        <Icon />
        <span class="sr-only">{text}</span>
      </TooltipTrigger>

      <TooltipContent class="flex items-center gap-4">{text}</TooltipContent>
    </Tooltip>
  )
}
