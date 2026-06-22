import { Button } from '~/components/ui/button'
import { TextField, TextFieldInput } from '~/components/ui/text-field'
import { SearchWorkspaces } from '~/features/components/home/homeTablePrevArea'

export const HomeTableSearchArea = (props: SearchWorkspaces) => {
  const { keyword, setKeyword, isSearching, handleSearch } = props

  return (
    <div class="flex items-center gap-2">
      <TextField value={keyword()} onChange={setKeyword}>
        <TextFieldInput
          placeholder="ワークスペースを検索..."
          class="max-w-sm"
        />
      </TextField>

      <Button onClick={handleSearch} disabled={isSearching()}>
        {isSearching() ? '検索中...' : '検索'}
      </Button>
    </div>
  )
}
