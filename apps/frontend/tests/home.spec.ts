import { test, expect } from '@playwright/test'

test.describe('Home Page E2E Tests', () => {
  let email: string
  const password = 'Password123!'

  test.beforeEach(async ({ page }) => {
    // 毎回新しいユーザーでテストを行う（データの独立性を保つため）
    const randomId = Math.random().toString(36).substring(2, 10)
    email = `home_test_${randomId}@example.com`

    await page.goto('http://localhost:3000/signup')
    await page.locator('input[name="firstName"]').fill('Taro')
    await page.locator('input[name="lastName"]').fill('Yamada')
    await page.locator('input[name="email"]').fill(email)
    await page.locator('input[name="password"]').fill(password)
    await page.locator('input[name="confirmPassword"]').fill(password)
    await page.locator('button[type="submit"]').click()

    await expect(page).toHaveURL('http://localhost:3000/', { timeout: 15000 })
  })

  test('ワークスペース一覧が表示されること', async ({ page }) => {
    // 初期状態ではワークスペースが0件のはずだが、テーブルヘッダーなどは見えるはず
    await expect(page.locator('text=ワークスペース名')).toBeVisible()
    await expect(page.locator('button', { hasText: '追加' })).toBeVisible()
    await expect(
      page.locator('input[placeholder="ワークスペースを検索..."]'),
    ).toBeVisible()
  })

  test('ワークスペースを新規作成できること', async ({ page }) => {
    await page.locator('button', { hasText: '追加' }).click()

    const workspaceName = 'Test Workspace'
    const workspaceSlug = `test-slug-${Math.random().toString(36).substring(2, 7)}`

    await page.locator('input[name="name"]').fill(workspaceName)
    await page.locator('input[name="slug"]').fill(workspaceSlug)
    await page.locator('button', { hasText: '追加' }).last().click() // モーダル内の「追加」ボタン

    // 作成後、一覧に表示されることを確認
    await expect(page.locator(`text=${workspaceName}`)).toBeVisible({
      timeout: 15000,
    })
    await expect(page.locator(`text=${workspaceSlug}`)).toBeVisible()
  })

  test('ワークスペースのバリデーションエラーが表示されること', async ({
    page,
  }) => {
    await page.locator('button', { hasText: '追加' }).click()

    // 空のまま「追加」ボタンを押す
    await page.locator('button', { hasText: '追加' }).last().click()

    // エラーメッセージが表示されることを確認
    const errorMessages = page.locator('.text-destructive')
    await expect(errorMessages.first()).toBeVisible()
  })

  test('ワークスペースの検索ができること', async ({ page }) => {
    // 2つワークスペースを作成
    const ws1 = {
      name: 'Alpha Project',
      slug: `alpha-${Math.random().toString(36).substring(2, 7)}`,
    }
    const ws2 = {
      name: 'Beta Project',
      slug: `beta-${Math.random().toString(36).substring(2, 7)}`,
    }

    for (const ws of [ws1, ws2]) {
      await page.locator('button', { hasText: '追加' }).click()
      await page.locator('input[name="name"]').fill(ws.name)
      await page.locator('input[name="slug"]').fill(ws.slug)
      await page.locator('button', { hasText: '追加' }).last().click()
      await expect(page.locator(`text=${ws.name}`)).toBeVisible({
        timeout: 15000,
      })
    }

    // "Alpha" で検索
    await page
      .locator('input[placeholder="ワークスペースを検索..."]')
      .fill('Alpha')
    await page.locator('button', { hasText: '検索' }).click()

    // Alpha は表示され、Beta は非表示になることを期待
    await expect(page.locator('text=Alpha Project')).toBeVisible({
      timeout: 15000,
    })
    await expect(page.locator('text=Beta Project')).not.toBeVisible({
      timeout: 15000,
    })

    // 検索ワードをクリアして検索
    await page.locator('input[placeholder="ワークスペースを検索..."]').fill('')
    await page.locator('button', { hasText: '検索' }).click()

    // 両方表示されることを期待
    await expect(page.locator('text=Alpha Project')).toBeVisible()
    await expect(page.locator('text=Beta Project')).toBeVisible()
  })

  test('ページネーションが正しく動作すること', async ({ page }) => {
    // 6個のワークスペースを作成する
    const wsBaseName = 'Pg'
    for (let i = 1; i <= 6; i++) {
      await page
        .getByRole('button', { name: '追加', exact: true })
        .first()
        .click()
      await page.locator('input[name="name"]').fill(`${wsBaseName} ${i}`)
      await page
        .locator('input[name="slug"]')
        .fill(`pg-${i}-${Math.random().toString(36).substring(2, 5)}`)
      const submitButton = page.locator('button[type="submit"]', {
        hasText: '追加',
      })
      await submitButton.click()
      await expect(
        page.getByRole('button', { name: '追加', exact: true }).first(),
      ).toBeEnabled({ timeout: 15000 })
    }

    // 作成後の状態を安定させる
    await expect(
      page.getByRole('cell', { name: `${wsBaseName} 6`, exact: true }).first(),
    ).toBeVisible({ timeout: 15000 })

    // 表示件数を5件に変更
    await page.locator('select').selectOption('5')

    // 1ページ目の確認（1が表示され、6が非表示）
    await expect(
      page.getByRole('cell', { name: `${wsBaseName} 1`, exact: true }).first(),
    ).toBeVisible()

    // 2ページ目に遷移
    await page.locator('button', { hasText: 'Next' }).click()
    await expect(
      page.getByRole('cell', { name: `${wsBaseName} 6`, exact: true }).first(),
    ).toBeVisible()

    // 1ページ目に戻る
    await page.locator('button', { hasText: 'Previous' }).click()
    await expect(
      page.getByRole('cell', { name: `${wsBaseName} 1`, exact: true }).first(),
    ).toBeVisible()
  })
})
