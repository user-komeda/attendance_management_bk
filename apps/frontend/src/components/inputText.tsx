export const InputText = ({ name, label }: { name: string; label: string }) => {
  const id = `input-${name}`
  return (
    <div>
      <label for={id} class="mb-2 block text-sm font-medium text-slate-900">
        {label}
      </label>
      <input
        id={id}
        name={name}
        type="text"
        class="w-full rounded-md border border-gray-300 bg-white px-4 py-3 text-sm text-slate-900 outline-blue-500"
        placeholder="Enter email"
      />
    </div>
  )
// 分岐がないはずなのにbranchが50%になるため無視
/* v8 ignore start */
}
/* v8 ignore stop */
