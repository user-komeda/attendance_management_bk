// @ts-check

import eslint from '@eslint/js'
import vitest from '@vitest/eslint-plugin'
import { defineConfig } from 'eslint/config'
import prettier from 'eslint-config-prettier'
import importPlugin from 'eslint-plugin-import'
import noRelativeImportPaths from 'eslint-plugin-no-relative-import-paths'
import testingLibrary from 'eslint-plugin-testing-library'
import unusedImports from 'eslint-plugin-unused-imports'
import { configs } from 'typescript-eslint'

export default defineConfig(
  eslint.configs.recommended,
  configs.recommendedTypeChecked,
  configs.stylisticTypeChecked,
  importPlugin.flatConfigs.recommended,
  importPlugin.flatConfigs.typescript,
  prettier,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
      },
    },
    settings: {
      'import/resolver': {
        typescript: {},
      },
      'import/internal-regex': '^~/',
    },
    plugins: {
      'unused-imports': unusedImports,
      'no-relative-import-paths': noRelativeImportPaths,
    },
    rules: {
      'no-relative-import-paths/no-relative-import-paths': 'error',
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
      'import/order': [
        'error',
        {
          groups: ['builtin', 'external', 'sibling', 'index', 'object', 'type'],
          alphabetize: { order: 'asc', caseInsensitive: false }, //グループ内でアルファベット順に並べるかを設定
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
  {
    files: ['tests/**'], // or any other pattern
    ...testingLibrary.configs['flat/dom'],
    plugins: {
      vitest,
    },
    rules: {
      ...vitest.configs.all.rules, // you can also use vitest.configs.all.rules to enable all rules
    },
  },
)
