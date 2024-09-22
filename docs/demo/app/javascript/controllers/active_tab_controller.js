import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-tab"
export default class extends Controller {
  static targets = ["tab"]
  static values = {
    activeClass: { type: String, default: "tab-active" }
  }

  connect() {}

  activate(event) {
    this.clear()

    event.target.closest("[role='tab']").classList.add(this.activeClassValue)
  }

  clear() {
    if (this.hasTabTarget) {
      this.tabTargets.forEach((tab) => {
        tab.classList.remove(this.activeClassValue)
      })
    }
  }
}
