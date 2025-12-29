// @ts-check
import eslint from '@eslint/js'
import vitest from '@vitest/eslint-plugin'
import { defineConfig } from 'eslint/config'
import prettier from 'eslint-config-prettier'
import importPlugin from 'eslint-plugin-import'
import noRelativeImportPaths from 'eslint-plugin-no-relative-import-paths'
import solid from 'eslint-plugin-solid/configs/typescript'
import testingLibrary from 'eslint-plugin-testing-library'
import unusedImports from 'eslint-plugin-unused-imports'
import { configs } from 'typescript-eslint'

export default defineConfig(
  eslint.configs.recommended,
  importPlugin.flatConfigs.recommended,
  importPlugin.flatConfigs.typescript,
  configs.strict,
  configs.stylistic,
  prettier,
  {
    ...solid,
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.json'],
        tsconfigRootDir: import.meta.dirname,
      },
    },

    settings: {
      'import/resolver': {
        typescript: {
          project: './tsconfig.json',
        },
      },
      'import/internal-regex': '^~/',
    },
    plugins: {
      'unused-imports': unusedImports,
      'no-relative-import-paths': noRelativeImportPaths,
    },
    rules: {
      'no-relative-import-paths/no-relative-import-paths': 'error',
      '@typescript-eslint/no-non-null-assertion': 'off',

      /* unused-imports */
      'unused-imports/no-unused-imports': 'error',
      'unused-imports/no-unused-vars': [
        'warn',
        {
          vars: 'all',
          varsIgnorePattern: '^_',
          args: 'after-used',
          argsIgnorePattern: '^_',
        },
      ],

      /* import order（import-plugin ありの場合のみ使用） */
      'import/order': [
        'error',
        {
          groups: ['builtin', 'external', 'sibling', 'index', 'object', 'type'],
          alphabetize: { order: 'asc', caseInsensitive: false },
          pathGroups: [
            {
              pattern: '{react,react-dom/**,react-router-dom,}',
              group: 'builtin',
              position: 'before',
            },
          ],
          pathGroupsExcludedImportTypes: ['builtin'],
          'newlines-between': 'always',
        },
      ],
    },
  },
  //   /* 👉 Test 用設定（Testing Library + Vitest） */
  {
    files: ['tests/**'],
    ...testingLibrary.configs['flat/dom'],
    plugins: {
      vitest,
    },
    rules: {
      ...vitest.configs.all.rules,
    },
  },
)
