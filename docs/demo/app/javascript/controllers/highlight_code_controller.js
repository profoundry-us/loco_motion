import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="highlight-code"
export default class extends Controller {
  connect() {
    hljs.highlightElement(this.element);
  }
}
