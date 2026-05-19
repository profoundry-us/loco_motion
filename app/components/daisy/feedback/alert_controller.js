import { Controller } from "@hotwired/stimulus"

/**
 * Alert Controller
 *
 * A Stimulus controller that manages alert dismissal and auto-dismissal.
 * Handles manual close actions and automatic dismissal after a
 * configurable timeout.
 */
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 0 }
  }

  connect() {
    if (this.timeoutValue > 0) {
      this.setupAutoDismiss()
    }
  }

  disconnect() {
    if (this.dismissTimer) {
      clearTimeout(this.dismissTimer)
    }
  }

  setupAutoDismiss() {
    this.dismissTimer = setTimeout(() => {
      this.close()
    }, this.timeoutValue)
  }

  close() {
    this.element.classList.add(
      'where:opacity-0',
      'where:transition-opacity',
      'where:duration-300'
    )

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
