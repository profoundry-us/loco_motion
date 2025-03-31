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
  }

  /**
   * Called when the controller is disconnected from the DOM.
   * Removes event listeners to prevent memory leaks.
   */
  disconnect() {
    window.removeEventListener('localstorage-update', this.storageChangeListener)
  }

  /**
   * Sets the appropriate radio input as checked based on the current theme.
   * This ensures the UI reflects the active theme.
   */
  setInput() {
    const theme = this.getCurrentTheme()
    const input = this.element.querySelector(`input[value='${theme}']`);

    if (input) {
      input.checked = true;
    }
  }

  /**
   * Changes the theme based on user selection.
   * Updates localStorage and dispatches a custom event to notify other controllers.
   *
   * @param {Event} event - The triggering click event
   */
  setTheme(event) {
    const input = event.currentTarget.querySelector('input')

    if (input) {
      localStorage.setItem("savedTheme", input.value)

      const updateEvent = new CustomEvent('localstorage-update', { detail: { key: 'savedTheme', newValue: input.value } })
      window.dispatchEvent(updateEvent)
    }

    event.preventDefault();
  }

  /**
   * Retrieves the current theme from localStorage or system preferences.
   *
   * @returns {string} The current theme name
   */
  getCurrentTheme() {
    const savedTheme = localStorage.getItem('savedTheme')

    if (savedTheme) {
      return savedTheme
    }

    const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    return isDarkMode ? 'dark' : 'light'
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
