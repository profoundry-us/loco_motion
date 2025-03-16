import { Controller } from "@hotwired/stimulus"

/**
 * Controls the gap size of a stack element using a range slider
 */
export default class extends Controller {
  static targets = ["stack", "slider", "label"]

  connect() {
    this.updateGap()
  }

  updateGap() {
    const value = this.sliderTarget.value
    
    // Update the stack's gap class
    this.stackTarget.classList.remove("gap-1", "gap-2", "gap-3", "gap-4", "gap-5")
    this.stackTarget.classList.add(`gap-${value}`)
    
    // Update the label
    this.labelTarget.textContent = value
  }
}
