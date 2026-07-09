import { Controller } from "@hotwired/stimulus"

// Drives the MasterDetailComponent: clicking a master "tab" reveals the matching
// detail "pane" and highlights the active tab. The first record is selected on
// connect.
export default class extends Controller {
  static targets = ["tab", "pane"]

  connect() {
    this.show(0)
  }

  select(event) {
    this.show(event.params.index)
  }

  show(index) {
    this.paneTargets.forEach((pane, i) => pane.classList.toggle("hidden", i !== index))
    this.tabTargets.forEach((tab, i) => {
      tab.classList.toggle("bg-base-200", i === index)
      tab.classList.toggle("font-semibold", i === index)
    })
  }
}
