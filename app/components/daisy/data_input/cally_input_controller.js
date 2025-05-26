import { Controller } from "@hotwired/stimulus"

/**
 * Controller for handling calendar input interactions.
 * Manages the popover calendar UI and synchronization between input and calendar elements.
 */
export default class extends Controller {
  static targets = ["calendar", "input", "popover"]

  /**
   * Initializes the controller and sets up event listeners.
   * Binds all methods to ensure proper 'this' context.
   *
   * @returns {void}
   */
  connect() {

    // Save the bound functions so we can remove them later
    this.boundUpdateInput = this.updateInput.bind(this)
    this.boundUpdateCalendar = this.updateCalendar.bind(this)
    this.boundOpenCalendar = this.openCalendar.bind(this)
    this.boundCloseCalendar = this.closeCalendar.bind(this)
    this.boundHandleKeydown = this.handleKeydown.bind(this)
    this.boundHandleToggle = this.handleToggle.bind(this)

    // Bind all of our functions
    this.calendarTarget.addEventListener("change", this.boundUpdateInput)
    this.calendarTarget.addEventListener("blur", this.boundCloseCalendar)

    this.inputTarget.addEventListener("change", this.boundUpdateCalendar)
    this.inputTarget.addEventListener("keyup", this.boundUpdateCalendar)
    this.inputTarget.addEventListener("click", this.boundOpenCalendar)
    this.inputTarget.addEventListener("keydown", this.boundHandleKeydown)

    this.popoverTarget.addEventListener("toggle", this.boundHandleToggle)
  }

  /**
   * Cleans up event listeners when the controller is disconnected.
   * Prevents memory leaks by removing all bound event handlers.
   *
   * @returns {void}
   */
  disconnect() {
    this.calendarTarget.removeEventListener("change", this.boundUpdateInput)
    this.calendarTarget.removeEventListener("blur", this.boundCloseCalendar)

    this.inputTarget.removeEventListener("change", this.boundUpdateCalendar)
    this.inputTarget.removeEventListener("keyup", this.boundUpdateCalendar)
    this.inputTarget.removeEventListener("keydown", this.boundHandleKeydown)
    this.inputTarget.removeEventListener("click", this.boundOpenCalendar)
    this.popoverTarget.removeEventListener("toggle", this.boundHandleToggle)
  }

  /**
   * Opens the calendar popover.
   *
   * @returns {void}
   */
  openCalendar() {
    // Open the popover
    this.popoverTarget.togglePopover(true)
  }

  /**
   * Closes the calendar popover if the blur event is not related to calendar elements.
   *
   * @param {FocusEvent} event - The blur event object.
   *
   * @returns {void}
   */
  closeCalendar(event) {
    // Don't close if we're still in the calendar elements
    if (event.relatedTarget && this.calendarTarget.contains(event.relatedTarget)) {
      return
    }

    this.popoverTarget.togglePopover(false)
  }

  /**
   * Opens the calendar if it is closed, or closes it if it is open.
   *
   * @returns {void}
   */
  toggleCalendar() {
    this.popoverTarget.togglePopover()
  }

  /**
   * Handles the popover toggle event.
   * - When opening: Sets a zero-width space in empty inputs to prevent floating label flicker
   * - When closing: Clears the single-space input to ensure proper floating label behavior
   *
   * @param {Event} event - The toggle event object with newState property
   * @returns {void}
   */
  handleToggle(event) {
    const hasFloatingLabel = this.inputTarget.parentElement.classList.contains("floating-label")
    const isOpen = event.newState == 'open'

    if (isOpen) {
      // Make sure the calendar is visible
      this.scrollCalendarIntoView()
    }

    if (hasFloatingLabel) {
      const ZERO_WIDTH_SPACE = '\u200B'

      if (isOpen) {
        // Set the input to a zero-width space if it is empty to prevent a floating label
        // flicker when the calendar loses focus while setting the date
        if (this.inputTarget.value == null || this.inputTarget.value === '') {
          this.inputTarget.value = ZERO_WIDTH_SPACE;
        }
      } else {
        // Unset the zero-width space input on close so the floating label works again
        if (this.inputTarget.value === ZERO_WIDTH_SPACE) {
          this.inputTarget.value = null
        }
      }
    }
  }

  /**
   * Ensures the calendar popover is visible within the viewport.
   *
   * If the popover extends beyond the viewport edges, scrolls the window to
   * bring it into view adding any data-auto-scroll-padding.
   *
   * @returns {void}
   */
  scrollCalendarIntoView() {
    const rect = this.popoverTarget.getBoundingClientRect()
    const autoScrollPadding = parseInt(this.popoverTarget.dataset.autoScrollPadding, 10)
    const padding = isNaN(autoScrollPadding) ? 0 : autoScrollPadding

    if (rect.bottom > window.innerHeight) {
      window.scrollBy({ top: rect.bottom - window.innerHeight + padding, behavior: 'smooth' })
    } else if (rect.top < 0) {
      window.scrollBy({ top: rect.top - padding, behavior: 'smooth' })
    }
  }

  /**
   * Updates the input value from the calendar and closes the popover.
   * Synchronizes the input field with the selected date.
   *
   * @returns {void}
   */
  updateInput() {
    // Update the input value and close the popover
    this.inputTarget.value = this.calendarTarget.value
    this.closeCalendar()
  }

  /**
   * Handles keyboard navigation for the calendar input.
   * - SPACE: Toggles the popover
   * - ENTER: Closes an open popover
   * - ARROW DOWN / ARROW UP: Opens the popover and focuses the calendar
   *
   * @param {KeyboardEvent} event - The keyboard event object.
   *
   * @returns {void}
   */
  handleKeydown(event) {
    const hasModifierKeys = event.ctrlKey || event.shiftKey || event.altKey || event.metaKey;
    const isOpen = this.popoverTarget.matches(':popover-open')

    //
    // SPACE - Toggles the popover.
    //
    if (event.key === ' ' || event.code === 'Space') {
      event.preventDefault()

      this.toggleCalendar()
    }

    //
    // ENTER - Closes an open popover
    //
    else if (isOpen && (event.key === 'Enter' || event.code === 'Enter')) {
      // Stop the enter key from triggering the form submission
      event.preventDefault()

      this.closeCalendar()
    }

    //
    // ARROW DOWN / ARROW UP - Opens the popover and focuses the calendar
    //
    else if ((event.key === 'ArrowDown' || event.code === 'ArrowUp') && !hasModifierKeys) {
      event.preventDefault()

      // If the calendar is not already open, open it
      if (!isOpen) {
        this.openCalendar()
      }

      // Focus the calendar element
      this.calendarTarget.focus()

      // Forward the keydown event to the calendar
      const forwardedEvent = new KeyboardEvent('keydown', {
        key: event.key,
        code: event.code,
        bubbles: true,
        cancelable: true,
      })

      // Dispatch the forwarded event to the calendar
      this.calendarTarget.dispatchEvent(forwardedEvent)
    }
  }

  /**
   * Updates the calendar's value based on the input field.
   * Only updates if the input contains a valid ISO 8601 date.
   *
   * @returns {void}
   */
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
