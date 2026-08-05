import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="active-tab"
//
// Drives JS-only tab switching per the ARIA tabs pattern: the active tab
// carries `tab-active` + `aria-selected="true"` (DaisyUI styles both as the
// active state, so they must stay in sync), and a roving tabindex keeps the
// tablist a single Tab stop — Left/Right arrows move between and activate
// tabs.
export default class extends Controller {
  static targets = ["tab"]
  static values = {
    activeClass: { type: String, default: "tab-active" }
  }

  connect() {
    // Establish the roving tabindex from the server-rendered active state.
    this.tabTargets.forEach((tab) => {
      const active = tab.classList.contains(this.activeClassValue)
      tab.setAttribute("tabindex", active ? "0" : "-1")
    })
  }

  activate(event) {
    this.select(event.target.closest("[role='tab']"))
  }

  activateNext(event) {
    this.step(event, 1)
  }

  activatePrevious(event) {
    this.step(event, -1)
  }

  // Activates the tab `delta` positions away (wrapping) and moves focus to
  // it, so arrow keys both navigate and select.
  step(event, delta) {
    const current = event.target.closest("[role='tab']")
    const index = this.tabTargets.indexOf(current)

    if (index === -1) return

    const count = this.tabTargets.length
    const next = this.tabTargets[(index + delta + count) % count]

    this.select(next)
    next.focus()
  }

  select(tab) {
    this.clear()

    tab.classList.add(this.activeClassValue)
    tab.setAttribute("aria-selected", "true")
    tab.setAttribute("tabindex", "0")
  }

  clear() {
    this.tabTargets.forEach((tab) => {
      tab.classList.remove(this.activeClassValue)
      tab.setAttribute("aria-selected", "false")
      tab.setAttribute("tabindex", "-1")
    })
  }
}
