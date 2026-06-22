import { Show, children } from 'solid-js'
import type { JSX } from 'solid-js'

import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '~/components/ui/card'

type CommonCardProps = {
  title: JSX.Element
  description?: JSX.Element
  footer?: JSX.Element
  children: JSX.Element
}

export const CommonCard = (props: CommonCardProps) => {
  const description = children(() => props.description)
  const footer = children(() => props.footer)

  return (
    <Card>
      <CardHeader>
        <CardTitle>{props.title}</CardTitle>
        <Show when={description()}>
          {(resolvedDescription) => (
            <CardDescription>{resolvedDescription()}</CardDescription>
          )}
        </Show>
      </CardHeader>

      <CardContent>{props.children}</CardContent>

      <Show when={footer()}>
        {(resolvedFooter) => <CardFooter>{resolvedFooter()}</CardFooter>}
      </Show>
    </Card>
  )
}
