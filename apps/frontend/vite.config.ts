import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

import { solidStart } from '@solidjs/start/config'
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

export default defineConfig({
  plugins: [tailwindcss(), solidStart()],
  resolve: {
    alias: {
      '~': resolve(__dirname, './src'),
    },
  },
  optimizeDeps: {
    include: [
      '@jridgewell/resolve-uri',
      '@jridgewell/sourcemap-codec',
      '@jridgewell/trace-mapping',
    ],
  },
})
