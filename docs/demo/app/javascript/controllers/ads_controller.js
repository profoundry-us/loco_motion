import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ads", "content", "hidden"]

  connect() {
  }

  disconnect() {
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
    this.contentTarget.classList.toggle("lg:pr-60", false)
  }

  show() {
    this.adsTarget.classList.toggle("lg:block!", true)
    this.contentTarget.classList.toggle("lg:pr-60", true)
  }
}
