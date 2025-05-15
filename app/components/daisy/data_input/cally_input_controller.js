import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calendar", "input", "popover"]

  connect() {

    // Save the bound functions so we can remove them later
    this.boundUpdateInput = this.updateInput.bind(this)
    this.boundUpdateCalendar = this.updateCalendar.bind(this)
    this.boundOpenCalendar = this.openCalendar.bind(this)
    this.boundCloseCalendar = this.closeCalendar.bind(this)
    this.boundHandleKeydown = this.handleKeydown.bind(this)

    // Bind all of our functions
    this.calendarTarget.addEventListener("change", this.boundUpdateInput)
    this.calendarTarget.addEventListener("blur", this.boundCloseCalendar)

    this.inputTarget.addEventListener("change", this.boundUpdateCalendar)
    this.inputTarget.addEventListener("keyup", this.boundUpdateCalendar)
    this.inputTarget.addEventListener("click", this.boundOpenCalendar)
    this.inputTarget.addEventListener("keydown", this.boundHandleKeydown)
  }

  disconnect() {
    this.calendarTarget.removeEventListener("change", this.boundUpdateInput)
    this.calendarTarget.removeEventListener("blur", this.boundCloseCalendar)

    this.inputTarget.removeEventListener("change", this.boundUpdateCalendar)
    this.inputTarget.removeEventListener("keyup", this.boundUpdateCalendar)
    this.inputTarget.removeEventListener("keydown", this.boundHandleKeydown)
    this.inputTarget.removeEventListener("click", this.boundOpenCalendar)
  }

  openCalendar() {

    // Open the popover
    this.popoverTarget.togglePopover(true)
  }

  closeCalendar(event) {
    // Don't close if we're still in the calendar elements
    if (event.relatedTarget && this.calendarTarget.contains(event.relatedTarget)) {
      return
    }

    this.popoverTarget.togglePopover(false)
  }

  updateInput() {
    // Update the input value and close the popover
    this.inputTarget.value = this.calendarTarget.value
    this.popoverTarget.togglePopover(false)
  }

  handleKeydown(event) {

    // Check if the key pressed is space
    if (event.key === ' ' || event.code === 'Space') {
      // Prevent the space from being added to the input
      event.preventDefault()

      // Toggle the calendar popover
      this.popoverTarget.togglePopover()
    }

    // Only handle the down arrow key for opening/navigating the calendar
    const downArrowKey = 'ArrowDown'

    // Only handle arrow keys when no modifier keys are pressed
    const noModifierKeys = !event.ctrlKey && !event.shiftKey && !event.altKey && !event.metaKey;

    if (event.key === downArrowKey && noModifierKeys) {
      // Prevent the default behavior on the input
      event.preventDefault()

      // If the calendar is not already open, open it
      if (this.popoverTarget.getAttribute('data-state') !== 'open') {
        this.popoverTarget.togglePopover(true)
      }

      // Focus the calendar element
      this.calendarTarget.focus()

      // Forward the keydown event to the calendar
      const forwardedEvent = new KeyboardEvent('keydown', {
        key: event.key,
        code: event.code,
        bubbles: true,
        cancelable: true,
        keyCode: event.keyCode
      })

      // Dispatch the forwarded event to the calendar
      this.calendarTarget.dispatchEvent(forwardedEvent)
    }
  }

  updateCalendar() {
    // Only update the calendar if we have a full / valid ISO 8601 date
    let newDate = this.inputTarget.value

    if (newDate.length !== 10 || new Date(newDate).toString() === "Invalid Date") {
      return
    }

    // Set the calendar value and focused-date attributes
    this.calendarTarget.value = newDate
    this.calendarTarget.setAttribute('focused-date', newDate)
  }
}
