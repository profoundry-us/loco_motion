import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidenavCheckbox"]

  // Only on first init (not on each connect), scroll the active item into view.
  initialize() {
    this.scrollActiveIntoView()
  }

  // Scroll the active item into view.
  scrollActiveIntoView() {
    let activeItem = this.element.querySelector("li a.active")

    if (activeItem) {
      let method = activeItem.scrollIntoViewIfNeeded ? "scrollIntoViewIfNeeded" : "scrollIntoView";

      activeItem[method]({ behavior: 'smooth' });
    }
  }

  // Reset all items to inactive.
  reset() {
    this.element.querySelectorAll("li a").forEach((link) => {
      link.classList.remove("active")
    })
  }

  activate(event) {
    this.reset()

    // Find the closest list item to the clicked element (which may be ourselves
    // or our parent) and then activate the link within it.
    //
    // This allows the user to click the <li> or the <a> elements and have the
    // same effect.
    event.target.closest("li").querySelector('a').classList.add("active")

    // Close the sidenav
    if (this.hasSidenavCheckboxTarget) {
      this.sidenavCheckboxTarget.checked = false
    }
  }
}
