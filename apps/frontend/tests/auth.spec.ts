import { test, expect, Page } from '@playwright/test'

test.describe('E2E Authentication Tests', () => {
  const safeGoto = async (page: Page, url: string) => {
    await page.goto(url, { waitUntil: 'domcontentloaded' })
    if (page.url().startsWith('chrome-error://')) {
      await page.goto(url, { waitUntil: 'domcontentloaded' })
    }
    await page.locator('body[data-hydrated="true"]').waitFor()
  }

  test('未ログインでトップページにアクセスするとログイン画面にリダイレクトされること', async ({
    page,
  }) => {
    await safeGoto(page, '/')

    await expect(page).toHaveURL('/signin', {
      timeout: 15000,
    })
    await expect(page.locator('input[name="email"]')).toBeVisible()
    await expect(page.locator('input[name="password"]')).toBeVisible()
  })

  test('新規登録画面でバリデーションエラーが表示されること', async ({
    page,
  }) => {
    await safeGoto(page, '/signup')

    // 入力フォームがロードされるのを待つ
    await page.locator('input[name="firstName"]').waitFor({ state: 'visible' })

    const submitBtn = page.locator('button[type="submit"]')
    await submitBtn.waitFor({ state: 'visible' })
    await submitBtn.click()

    // バリデーションで送信が通らず、登録画面に留まることを確認
    await expect(page).toHaveURL('/signup', {
      timeout: 10000,
    })
    await expect(page.locator('input[name="firstName"]')).toBeVisible()
  })

  test('ログイン画面でバリデーションエラーまたは認証エラーが表示されること', async ({
    page,
  }) => {
    await safeGoto(page, '/signin')

    // 入力フォームがロードされるのを待つ
    await page.locator('input[name="email"]').waitFor({ state: 'visible' })

    // バリデーションで必ず弾かれる値を入力
    await page.locator('input[name="email"]').fill('invalid-email')
    await page.locator('input[name="password"]').fill('test9219')

    const submitBtn = page.locator('button[type="submit"]')
    await submitBtn.waitFor({ state: 'visible' })
    await submitBtn.click()

    // バリデーションで送信が通らず、ログイン画面に留まることを確認
    await expect(page).toHaveURL('/signin', {
      timeout: 10000,
    })
    await expect(page.locator('input[name="email"]')).toBeVisible()
  })

  test('正しい情報を入力して新規登録し、トップページにリダイレクトされること', async ({
    page,
  }) => {
    await safeGoto(page, '/signup')

    // 入力フォームがロードされるのを待つ
    await page.locator('input[name="firstName"]').waitFor({ state: 'visible' })

    const randomId = Math.random().toString(36).substring(2, 10)
    const email = `testuser_${randomId}@example.com`

    await page.locator('input[name="firstName"]').fill('Taro')
    await page.locator('input[name="lastName"]').fill('Yamada')
    await page.locator('input[name="email"]').fill(email)
    await page.locator('input[name="password"]').fill('Password123!')
    await page.locator('input[name="confirmPassword"]').fill('Password123!')

    const submitBtn = page.locator('button[type="submit"]')
    await submitBtn.waitFor({ state: 'visible' })
    await submitBtn.click()

    // 登録成功後のリダイレクト先（トップページ '/'）に遷移することを期待
    await expect(page).toHaveURL('/', { timeout: 15000 })
    await expect(page.locator('button', { hasText: '追加' })).toBeVisible()
  })

  test('正しい情報を入力してログインし、トップページにリダイレクトされること', async ({
    page,
  }) => {
    const randomId = Math.random().toString(36).substring(2, 10)
    const email = `signin_user_${randomId}@example.com`
    const password = 'Password123!'

    await safeGoto(page, '/signup')

    // 入力フォームがロードされるのを待つ
    await page.locator('input[name="firstName"]').waitFor({ state: 'visible' })

    await page.locator('input[name="firstName"]').fill('Taro')
    await page.locator('input[name="lastName"]').fill('Yamada')
    await page.locator('input[name="email"]').fill(email)
    await page.locator('input[name="password"]').fill(password)
    await page.locator('input[name="confirmPassword"]').fill(password)

    const signupSubmitBtn = page.locator('button[type="submit"]')
    await signupSubmitBtn.waitFor({ state: 'visible' })
    await signupSubmitBtn.click()

    // signup 成功後、トップページに遷移することを確認
    await expect(page).toHaveURL('/', { timeout: 15000 })

    // signup 時点でログイン済みになるため、signin テスト前にセッションを消す
    await page.context().clearCookies()

    await safeGoto(page, '/signin')

    // 入力フォームがロードされるのを待つ
    await page.locator('input[name="email"]').waitFor({ state: 'visible' })

    await page.locator('input[name="email"]').fill(email)
    await page.locator('input[name="password"]').fill(password)

    const signinSubmitBtn = page.locator('button[type="submit"]')
    await signinSubmitBtn.waitFor({ state: 'visible' })
    await signinSubmitBtn.click()

    // signin 成功後のリダイレクト先（トップページ '/'）に遷移することを期待
    await expect(page).toHaveURL('/', { timeout: 15000 })
    await expect(page.locator('button', { hasText: '追加' })).toBeVisible()
  })
})
