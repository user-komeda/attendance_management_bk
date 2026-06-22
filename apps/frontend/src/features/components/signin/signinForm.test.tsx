import { useSubmission } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import type { Action, Submission } from '@solidjs/router'
import type { SigninSchema } from '~/schema/signinSchema'
import type { ActionResultOf } from '~/types/action'

import { SigninForm } from '~/features/components/signin/signinForm'

// mock useSubmission
vi.mock(import('@solidjs/router'), async () => {
  const actual = await vi.importActual('@solidjs/router')
  return {
    ...actual,
    useSubmission: vi.fn(),
  }
})

// eslint-disable-next-line max-lines-per-function
describe(SigninForm, () => {
  it('should render (signin) form', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: undefined,
      pending: false,
    } as unknown as Submission<[FormData], ActionResultOf<typeof SigninSchema>>)

    render(() => (
      <SigninForm
        action={
          vi.fn() as unknown as Action<
            [FormData],
            ActionResultOf<typeof SigninSchema>,
            [FormData]
          >
        }
      />
    ))

    expect(screen.getByLabelText('Email')).toBeInTheDocument()
    expect(screen.getByLabelText('Password')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument()
  })

  it('should display errors when submission result has errors', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: {
        ok: false,
        fieldErrors: [
          { key: 'email', message: 'Invalid email' },
          { key: 'password', message: 'Password is required' },
        ],
      },
      pending: false,
    } as unknown as Submission<[FormData], ActionResultOf<typeof SigninSchema>>)

    render(() => (
      <SigninForm
        action={
          vi.fn() as unknown as Action<
            [FormData],
            ActionResultOf<typeof SigninSchema>,
            [FormData]
          >
        }
      />
    ))

    expect(screen.getByText('Invalid email')).toBeInTheDocument()
    expect(screen.getByText('Password is required')).toBeInTheDocument()
  })

  it('should display general error message', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: {
        ok: false,
        message: 'Something went wrong',
      },
      pending: false,
    } as unknown as Submission<[FormData], ActionResultOf<typeof SigninSchema>>)

    render(() => (
      <SigninForm
        action={
          vi.fn() as unknown as Action<
            [FormData],
            ActionResultOf<typeof SigninSchema>,
            [FormData]
          >
        }
      />
    ))

    expect(screen.getByText('Something went wrong')).toBeInTheDocument()
  })

  it('pending中もログインボタンが表示されること', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: undefined,
      pending: true,
    } as unknown as Submission<[FormData], ActionResultOf<typeof SigninSchema>>)

    render(() => (
      <SigninForm
        action={
          vi.fn() as unknown as Action<
            [FormData],
            ActionResultOf<typeof SigninSchema>,
            [FormData]
          >
        }
      />
    ))

    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument()
  })
})
