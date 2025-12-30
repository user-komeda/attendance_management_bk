/* eslint-disable @typescript-eslint/no-explicit-any */
import { useSubmission } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { SigninForm } from '~/features/components/signin/signinForm'

// mock useSubmission
vi.mock('@solidjs/router', async () => {
  const actual = await vi.importActual('@solidjs/router')
  return {
    ...actual,
    useSubmission: vi.fn(),
  }
})

describe('SigninForm', () => {
  it('should render signin form', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: undefined,
      pending: false,
    } as any)

    render(() => <SigninForm action={vi.fn() as any} />)

    expect(screen.getByLabelText('Email')).toBeInTheDocument()
    expect(screen.getByLabelText('Password')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument()
  })

  it('should display errors when submission result has errors', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: {
        error: [
          { key: 'email', message: 'Invalid email' },
          { key: 'password', message: 'Password is required' },
        ],
      },
      pending: false,
    } as any)

    render(() => <SigninForm action={vi.fn() as any} />)

    expect(screen.getByText('Invalid email')).toBeInTheDocument()
    expect(screen.getByText('Password is required')).toBeInTheDocument()
  })
})
