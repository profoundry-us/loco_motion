import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="input-demo"
//
// Echoes whatever the wired input reports so the `action:` examples on the
// data-input pages show the event firing. Each input's `action:` omits the
// event name on purpose: Stimulus picks the element's default (`input` for
// text controls, `change` for selects, checkboxes, radios, and file inputs).
export default class InputDemoController extends Controller {
  static targets = ["output"]

  changed(event) {
    const el = event.target
    let value

    if (el.type === "checkbox" || el.type === "radio") {
      value = el.checked ? `checked (${el.value})` : "unchecked"
    } else if (el.type === "file") {
      value = Array.from(el.files).map((f) => f.name).join(", ") || "no file"
    } else {
      value = el.value === "" ? "(empty)" : el.value
    }

    this.outputTarget.textContent = `${event.type}: ${value}`
  }
}
