import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="doc-example"
export default class DocExampleController extends Controller {
  static targets = [ "preview", "template" ]

  // Allows the viewer to reset examples if they have altered them
  reset() {
    if (this.hasTemplateTarget && this.hasPreviewTarget) {
      this.previewTarget.innerHTML = this.templateTarget.innerHTML
    }
  }
}
