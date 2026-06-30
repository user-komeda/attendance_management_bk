import { TableCell, TableRow } from '~/components/ui/table'

export const FailbackTable = (props: { length: number }) => {
  return (
    <TableRow>
      <TableCell colSpan={props.length} class="h-24 text-center">
        No results.
      </TableCell>
    </TableRow>
  )
}
