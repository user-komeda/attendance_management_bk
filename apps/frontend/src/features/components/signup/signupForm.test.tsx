/* eslint-disable @typescript-eslint/no-explicit-any */

import { useSubmission } from '@solidjs/router'
import { render, screen } from '@solidjs/testing-library'
import { describe, it, expect, vi } from 'vitest'

import { SignupForm } from '~/features/components/signup/signupForm'

// mock useSubmission
vi.mock('@solidjs/router', async () => {
  const actual = await vi.importActual('@solidjs/router')
  return {
    ...actual,
    useSubmission: vi.fn(),
  }
})

describe('SignupForm', () => {
  it('should render signup form', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: undefined,
      pending: false,
    } as any)

    render(() => <SignupForm action={vi.fn() as any} />)

    expect(screen.getByLabelText('firstName')).toBeInTheDocument()
    expect(screen.getByLabelText('lastName')).toBeInTheDocument()
    expect(screen.getByLabelText('Email')).toBeInTheDocument()
    expect(screen.getByLabelText('Password')).toBeInTheDocument()
    expect(screen.getByLabelText('Confirm Password')).toBeInTheDocument()
    expect(
      screen.getByRole('button', { name: /Create an account/i }),
    ).toBeInTheDocument()
  })

  it('should display errors when submission result has errors', () => {
    vi.mocked(useSubmission).mockReturnValue({
      result: {
        error: [
          { key: 'firstName', message: 'First name is required' },
          { key: 'email', message: 'Invalid email' },
        ],
      },
      pending: false,
    } as any)

    render(() => <SignupForm action={vi.fn() as any} />)

    expect(screen.getByText('First name is required')).toBeInTheDocument()
    expect(screen.getByText('Invalid email')).toBeInTheDocument()
  })
})
