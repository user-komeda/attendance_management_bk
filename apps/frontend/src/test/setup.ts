import '@testing-library/jest-dom'
import { cleanup } from '@solidjs/testing-library'
import { afterEach } from 'vitest'

afterEach(() => {
  cleanup()
})

if (
  typeof HTMLFormElement !== 'undefined' &&
  !HTMLFormElement.prototype.requestSubmit
) {
  HTMLFormElement.prototype.requestSubmit = function (submitter) {
    if (submitter) {
      if (
        !(
          submitter instanceof HTMLInputElement ||
          submitter instanceof HTMLButtonElement
        )
      ) {
        throw new TypeError(
          'The specified element is not of type HTMLInputElement or HTMLButtonElement.',
        )
      }
      if (submitter.type !== 'submit') {
        throw new TypeError('The specified element is not a submit button.')
      }
      if (submitter.form !== this) {
        throw new Error(
          'The specified element is not owned by this form element.',
        )
      }
      submitter.click()
    } else {
      const submitButtons = this.querySelectorAll(
        'button[type="submit"], input[type="submit"]',
      )
      if (submitButtons.length > 0) {
        ;(submitButtons[0] as HTMLButtonElement).click()
      } else {
        const submitEvent = new Event('submit', {
          bubbles: true,
          cancelable: true,
        })
        this.dispatchEvent(submitEvent)
      }
    }
  }
}
