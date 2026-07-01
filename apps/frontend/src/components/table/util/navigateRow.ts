import { useNavigate } from '@solidjs/router'

export const navigateRow = (
  navigate: ReturnType<typeof useNavigate>,
  href: () => string | undefined,
) => {
  const rowHref = href()

  if (!rowHref) {
    return
  }

  navigate(rowHref)
}
