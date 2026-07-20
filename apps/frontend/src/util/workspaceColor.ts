export const workspaceIconPalette = [
  'bg-slate-500 text-slate-200',
  'bg-zinc-500 text-zinc-200',
  'bg-neutral-500 text-neutral-200',

  'bg-red-100 text-red-500',
  'bg-orange-100 text-orange-500',
  'bg-amber-100 text-amber-600',
  'bg-yellow-100 text-yellow-600',

  'bg-lime-900 text-lime-400',
  'bg-green-100 text-green-500',
  'bg-emerald-100 text-emerald-500',
  'bg-teal-100 text-teal-500',
  'bg-cyan-900 text-cyan-400',

  'bg-sky-100 text-sky-500',
  'bg-blue-700 text-blue-300',
  'bg-indigo-100 text-indigo-500',
  'bg-violet-100 text-violet-500',
  'bg-purple-100 text-purple-500',
  'bg-fuchsia-100 text-fuchsia-500',
  'bg-pink-100 text-pink-400',
  'bg-rose-100 text-rose-500',
]
export const getWorkspaceColor = (key: string) => {
  let hash = 0

  for (let i = 0; i < key.length; i++) {
    hash = key.charCodeAt(i) + ((hash << 5) - hash)
  }

  const index = Math.abs(hash) % workspaceIconPalette.length

  return workspaceIconPalette[index]
}
