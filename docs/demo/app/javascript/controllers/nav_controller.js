import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidenavCheckbox"]

  // Only on first init (not on each connect), scroll the active item into view.
  initialize() {
    this.scrollActiveIntoView()
  }

  connect() {
    this.turboLoadListener = this.turboLoad.bind(this)
    this.turboFetchRequestListener = this.turboFetchRequest.bind(this)

    document.addEventListener('turbo:load', this.turboLoadListener)
    document.addEventListener('turbo:fetch-request', this.turboFetchRequestListener)
  }

  disconnect() {
    document.removeEventListener('turbo:load', this.turboLoadListener)
    document.removeEventListener('turbo:fetch-request', this.turboFetchRequestListener)
  }

  turboLoad() {
    this.refresh()
  }

  turboFetchRequest() {
    this.refresh()
  }

  // Scroll the active item into view.
  scrollActiveIntoView() {
    let activeItem = this.element.querySelector("li a.menu-active")

    if (activeItem) {
      let method = activeItem.scrollIntoViewIfNeeded ? "scrollIntoViewIfNeeded" : "scrollIntoView";

      activeItem[method]({ behavior: 'smooth' });
    }
  }

  scrollDocumentToTop() {
    window.setTimeout(() => {
      document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
    }, 100)
  }

  // Refresh all links when the page changes
  refresh() {
    this.reset()
    this.activateItemByUrl()
    this.scrollActiveIntoView()
    this.scrollDocumentToTop()

    // Close the sidenav
    if (this.hasSidenavCheckboxTarget) {
      this.sidenavCheckboxTarget.checked = false
    }
  }

  // Reset all items to inactive.
  reset() {
    this.element.querySelectorAll("li a").forEach((link) => {
      link.classList.remove("menu-active")
    })
  }

  activateItemByUrl() {
    let activeItem = this.element.querySelector(`li a[href="${window.location.pathname}"]`)

    if (activeItem) {
      activeItem.classList.add("menu-active")
    }
  }
}
