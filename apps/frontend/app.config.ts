import { defineConfig } from '@solidjs/start/config'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  vite: {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    plugins: [tailwindcss() as any],
  },
})
