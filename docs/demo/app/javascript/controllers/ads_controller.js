import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ads", "content", "hidden"]

  connect() {
    this.turboLoadListener = this.turboLoad.bind(this)
    document.addEventListener('turbo:load', this.turboLoadListener)
  }

  disconnect() {
    document.removeEventListener('turbo:load', this.turboLoadListener)
  }

  turboLoad() {
    this.refresh()
  }

  refresh() {
    if (this.hasHiddenTarget) {
      this.hide()
    } else {
      this.show()
    }
  }

  hide() {
    this.adsTarget.classList.toggle("lg:block!", false)
    this.contentTarget.classList.toggle("lg:pr-64", false)
  }

  show() {
    this.adsTarget.classList.toggle("lg:block!", true)
    this.contentTarget.classList.toggle("lg:pr-64", true)
  }
}
