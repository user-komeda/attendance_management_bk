import { test, expect } from '@playwright/test'

test.describe('Workspace Detail E2E Tests', () => {
  let email: string
  const password = 'Password123!'

  test.beforeEach(async ({ page }) => {
    const randomId = Math.random().toString(36).substring(2, 10)
    email = `workspace_detail_test_${randomId}@example.com`

    await page.goto('http://localhost:3000/signup', {
      waitUntil: 'domcontentloaded',
    })
    if (page.url().startsWith('chrome-error://')) {
      await page.goto('http://localhost:3000/signup', {
        waitUntil: 'domcontentloaded',
      })
    }

    await page.locator('input[name="firstName"]').waitFor()
    await page.locator('input[name="firstName"]').fill('Taro')
    await page.locator('input[name="lastName"]').fill('Yamada')
    await page.locator('input[name="email"]').fill(email)
    await page.locator('input[name="password"]').fill(password)
    await page.locator('input[name="confirmPassword"]').fill(password)
    await page.locator('button[type="submit"]').click()

    await expect(page).toHaveURL('http://localhost:3000/', { timeout: 15000 })
  })

  test('ワークスペース行を押下すると詳細ページに遷移できること', async ({
    page,
  }) => {
    await page.locator('button', { hasText: '追加' }).click()

    const workspaceName = 'Workspace For Detail'
    const workspaceSlug = `detail-slug-${Math.random().toString(36).substring(2, 7)}`

    await page.locator('input[name="name"]').fill(workspaceName)
    await page.locator('input[name="slug"]').fill(workspaceSlug)
    await page.locator('button', { hasText: '追加' }).last().click()

    const targetCell = page.getByRole('cell', {
      name: workspaceName,
      exact: true,
    })
    await expect(targetCell).toBeVisible({ timeout: 15000 })

    await targetCell.click()

    await expect(page).toHaveURL(
      `http://localhost:3000/workspaces/${workspaceSlug}`,
      {
        timeout: 15000,
      },
    )
    await expect(page.locator('input[name="name"]')).toBeVisible()
  })

  test('ワークスペース詳細でContent APIを作成できること', async ({ page }) => {
    await page.locator('button', { hasText: '追加' }).click()

    const workspaceName = 'Workspace For ContentApi'
    const workspaceSlug = `content-api-${Math.random().toString(36).substring(2, 7)}`

    await page.locator('input[name="name"]').fill(workspaceName)
    await page.locator('input[name="slug"]').fill(workspaceSlug)
    await page.locator('button', { hasText: '追加' }).last().click()

    const targetCell = page.getByRole('cell', {
      name: workspaceName,
      exact: true,
    })
    await expect(targetCell).toBeVisible({ timeout: 15000 })
    await targetCell.click()

    await expect(page).toHaveURL(
      `http://localhost:3000/workspaces/${workspaceSlug}`,
      {
        timeout: 15000,
      },
    )

    await page.locator('input[name="name"]').fill('記事API')
    await page.locator('input[name="endpoint"]').fill('articles')
    await page.getByRole('button', { name: '次へ' }).click()
    await page.getByRole('button', { name: '次へ' }).click()

    await page.locator('input[name="fields[0][fieldId]"]').fill('title')
    await page.locator('input[name="fields[0][displayName]"]').fill('タイトル')
    await page
      .locator('select[name="fields[0][fieldType]"]')
      .selectOption('text')

    await page.getByRole('button', { name: '作成' }).click()

    await expect(page).toHaveURL('http://localhost:3000/', {
      timeout: 15000,
    })
    await expect(
      page.locator('button', { hasText: '追加' }).first(),
    ).toBeVisible()
  })

  test('ワークスペース詳細で必須入力のバリデーションエラーが表示されること', async ({
    page,
  }) => {
    await page.locator('button', { hasText: '追加' }).click()
    const workspaceName = 'Workspace For Validation'
    const workspaceSlug = `validation-${Math.random().toString(36).substring(2, 7)}`

    await page.locator('input[name="name"]').fill(workspaceName)
    await page.locator('input[name="slug"]').fill(workspaceSlug)
    await page.locator('button', { hasText: '追加' }).last().click()
    await page.getByRole('cell', { name: workspaceName, exact: true }).click()

    await expect(page).toHaveURL(
      `http://localhost:3000/workspaces/${workspaceSlug}`,
    )
    await expect(page.getByRole('button', { name: '次へ' })).toBeVisible()

    await page.getByRole('button', { name: '次へ' }).click()

    await expect(page.locator('text=API名を入力してください')).toBeVisible()
    await expect(
      page.locator(
        'text=エンドポイントは3〜32文字の英小文字・数字・ハイフン・アンダースコアで入力してください',
      ),
    ).toBeVisible()
  })

  test('ワークスペース詳細で作成失敗時にエラー表示されること', async ({
    page,
  }) => {
    await page.locator('button', { hasText: '追加' }).click()
    const workspaceName = 'Workspace For Error'
    const errorSlug = `error-${Math.random().toString(36).substring(2, 7)}`

    await page.locator('input[name="name"]').fill(workspaceName)
    await page.locator('input[name="slug"]').fill(errorSlug)
    await page.locator('button', { hasText: '追加' }).last().click()
    await page.getByRole('cell', { name: workspaceName, exact: true }).click()

    await page.route('**/api/workspaces/*/contentApi', async (route) => {
      await route.fulfill({
        status: 500,
        contentType: 'application/json',
        body: JSON.stringify({
          ok: false,
          message: '作成に失敗しました',
          fieldErrors: [],
        }),
      })
    })

    await expect(page).toHaveURL(
      `http://localhost:3000/workspaces/${errorSlug}`,
    )
    await expect(page.getByRole('button', { name: '次へ' })).toBeVisible()

    await page.locator('input[name="name"]').fill('失敗確認API')
    await page.locator('input[name="endpoint"]').fill('failed-endpoint')
    await page.getByRole('button', { name: '次へ' }).click()
    await page.getByRole('button', { name: '次へ' }).click()

    await page.locator('input[name="fields[0][fieldId]"]').fill('title')
    await page.locator('input[name="fields[0][displayName]"]').fill('タイトル')
    await page
      .locator('select[name="fields[0][fieldType]"]')
      .selectOption('text')

    await page.getByRole('button', { name: '作成' }).click()

    await expect(page).toHaveURL(
      `http://localhost:3000/workspaces/${errorSlug}`,
    )
    await expect(
      page.locator('p:visible', { hasText: '作成に失敗しました' }).first(),
    ).toBeVisible()
  })

  test('存在しないslugで詳細ページにアクセスするとエラー表示されること', async ({
    page,
  }) => {
    const notFoundSlug = `not-found-${Math.random().toString(36).substring(2, 7)}`

    await page.goto(`http://localhost:3000/workspaces/${notFoundSlug}`)

    await expect(
      page
        .getByText('Failed to load workspace detail', { exact: true })
        .first(),
    ).toBeVisible({ timeout: 15000 })
    await expect(page.locator('input[name="name"]')).toBeHidden()
  })
})
