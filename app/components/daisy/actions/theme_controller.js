/**
 * Theme Controller
 *
 * A Stimulus controller that manages theme selection and persistence.
 * It handles theme switching, localStorage persistence, and synchronization
 * across multiple theme selectors on the same page.
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  /**
   * Called when the controller is connected to the DOM.
   * Sets the initial theme input state and sets up event listeners.
   */
  connect() {
    this.setInput()

    // Setup a custom listener to watch for changes on the page in case the
    // page has multiple theme selectors
    this.storageChangeListener = this.storageChanged.bind(this)
    window.addEventListener('localstorage-update', this.storageChangeListener)

    // Automatically persist + sync whenever a theme input within this
    // controller changes. This means consumers do NOT need to wire up a
    // `setTheme` action on each radio/checkbox — simply changing the input is
    // enough to save the theme and keep every other selector in sync.
    this.inputChangeListener = this.handleInputChange.bind(this)
    this.element.addEventListener('change', this.inputChangeListener)
  }

  /**
   * Called when the controller is disconnected from the DOM.
   * Removes event listeners to prevent memory leaks.
   */
  disconnect() {
    window.removeEventListener('localstorage-update', this.storageChangeListener)
    this.element.removeEventListener('change', this.inputChangeListener)
  }

  /**
   * Syncs the radio inputs within this controller to the current theme.
   * The input matching the active theme is checked and every other
   * theme-controller input is unchecked, so a selection made in one selector
   * never leaves a stale `:checked` input behind in another.
   */
  setInput() {
    const theme = this.getCurrentTheme()
    const inputs = this.element.querySelectorAll('input.theme-controller')

    inputs.forEach((input) => {
      input.checked = input.value === theme
    })
  }

  /**
   * Clears the user's theme preference from localStorage.
   * Removes the saved theme and dispatches an event to notify other controllers.
   * Also removes the data-theme attribute from the document element.
   *
   * @param {Event} event - The triggering click event
   */
  clearTheme(event) {
    // If we are passed a themeName parameter, clear all inputs with that theme
    if (event && event.params && event.params.themeName) {
      const inputs = document.querySelectorAll(`input[name='${event.params.themeName}']`)

      if (inputs) {
        inputs.forEach(input => {
          input.checked = false
        })
      }
    }

    // Remove the savedTheme from local storage
    localStorage.removeItem("savedTheme")

    // Remove the data-theme attribute from the document element
    document.documentElement.removeAttribute('data-theme')

    // Fire off an update
    const updateEvent = new CustomEvent('localstorage-update', { detail: { key: 'savedTheme', newValue: null } })
    window.dispatchEvent(updateEvent)
  }

  /**
   * Changes the theme based on user selection.
   * Updates localStorage and dispatches a custom event to notify other controllers.
   *
   * Supports two markup patterns:
   *   1. The action is placed on a wrapper element that contains an `<input>`
   *      (e.g. the Custom Switcher's `<a>` links).
   *   2. The action is placed directly on the `<input>` itself.
   *
   * @param {Event} event - The triggering click event
   */
  setTheme(event) {
    const target = event.currentTarget
    const input = target.matches && target.matches('input')
      ? target
      : target.querySelector('input')

    if (input) {
      this.applyTheme(input.value)
    }

    event.preventDefault()
  }

  /**
   * Handles `change` events bubbling up from any theme-controller input within
   * this controller. Persists and broadcasts the newly selected theme so every
   * other selector stays in sync — no per-input action wiring required.
   *
   * @param {Event} event - The triggering change event
   */
  handleInputChange(event) {
    const input = event.target

    if (!input || !input.classList || !input.classList.contains('theme-controller')) return
    if (!input.checked) return

    this.applyTheme(input.value)
  }

  /**
   * Persists the given theme, applies it to the document, and notifies every
   * other theme controller on the page so they can sync their inputs.
   *
   * @param {string} value - The theme name to apply
   */
  applyTheme(value) {
    localStorage.setItem("savedTheme", value)
    document.documentElement.setAttribute('data-theme', value)

    const updateEvent = new CustomEvent('localstorage-update', { detail: { key: 'savedTheme', newValue: value } })
    window.dispatchEvent(updateEvent)
  }

  /**
   * Retrieves the current theme from localStorage.
   *
   * @returns {string} The current theme name
   */
  getCurrentTheme() {
    const savedTheme = localStorage.getItem('savedTheme')

    if (savedTheme) {
      return savedTheme
    }
  }

  /**
   * Event handler for 'localstorage-update' events.
   * Updates the input state when theme changes in another controller.
   *
   * @param {CustomEvent} event - The storage changed event
   */
  storageChanged(event) {
    this.setInput()
  }
}
