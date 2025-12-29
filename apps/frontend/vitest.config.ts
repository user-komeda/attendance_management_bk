/* eslint-disable @typescript-eslint/no-explicit-any */

import { resolve } from 'node:path'

import solid from 'vite-plugin-solid'
import { defineConfig } from 'vitest/config'

export default defineConfig({
  plugins: [solid() as any],
  resolve: {
    preserveSymlinks: true,
    conditions: ['development', 'browser'],
    alias: {
      '~': resolve(__dirname, './src'),
    },
  },
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: ['src/**/*.{ts,tsx}'],
      exclude: [
        'src/app.tsx',
        'src/entry-client.tsx',
        'src/entry-server.tsx',
        'src/global.d.ts',
      ],
    },
    server: {
      deps: {
        inline: ['@solidjs/router', '@solidjs/start', 'solid-js', 'valibot'],
      },
    },
  },
})
