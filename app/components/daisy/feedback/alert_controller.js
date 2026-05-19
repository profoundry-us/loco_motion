import { Controller } from "@hotwired/stimulus"

/**
 * Alert Controller
 *
 * A Stimulus controller that manages alert dismissal and auto-dismissal.
 * Handles manual close actions and automatic dismissal after a configurable timeout.
 */
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 0 }
  }

  /**
   * Called when the controller is connected to the DOM.
   * Sets up auto-dismiss timer if timeout is greater than 0.
   */
  connect() {
    this.timeoutValue = this.element.dataset.timeout || this.timeoutValue

    if (this.timeoutValue > 0) {
      this.setupAutoDismiss()
    }
  }

  /**
   * Called when the controller is disconnected from the DOM.
   * Clears the auto-dismiss timer to prevent memory leaks.
   */
  disconnect() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }
  }

  /**
   * Sets up the auto-dismiss timer based on the configured timeout.
   */
  setupAutoDismiss() {
    this.dismissTimer = setTimeout(() => {
      this.close()
    }, this.timeoutValue)
  }

  /**
   * Closes the alert with a smooth transition and removes it from the DOM.
   */
  close() {
    // Add a class to trigger the transition
    this.element.classList.add('where:opacity-0', 'where:transition-opacity', 'where:duration-300')

    // Wait for the transition to complete before removing the element
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
