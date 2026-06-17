import { Controller } from "@hotwired/stimulus"

/**
 * Modal Controller
 *
 * A Stimulus controller that opens and closes a native `<dialog>` modal and
 * emits lifecycle events. LocoMotion attaches it to the `<dialog>` element
 * automatically (via `data-controller="loco-modal"`), so `this.element` is the
 * dialog itself.
 *
 * Register it as `loco-modal` (see the Install guide) to enable the API. It is
 * inert until registered, so modals keep working without it.
 *
 * Actions:
 *
 *   - `loco-modal#open`  — shows the dialog and dispatches `loco-modal:open`.
 *   - `loco-modal#close` — closes the dialog, which dispatches
 *     `loco-modal:close`.
 *
 * Events (both bubble, so you can listen for them on any ancestor):
 *
 *   - `loco-modal:open`  — dispatched after the dialog is shown.
 *   - `loco-modal:close` — dispatched after the dialog is closed by ANY means
 *     (the Escape key, the backdrop, a `<form method="dialog">` submit, or the
 *     `close` action). The native `<dialog>` `close` event does not bubble, so
 *     the controller re-dispatches a bubbling `loco-modal:close` in its place.
 *
 * Turbo Frame (Global Modal): set the `turboFrame` value
 * (`data-loco-modal-turbo-frame-value`) to a `<turbo-frame>` id and the
 * controller opens the dialog when that frame finishes loading and clears it on
 * close — the canonical Hotwire pattern for one shared, lazily-filled modal.
 */
export default class extends Controller {
  static values = { turboFrame: String }

  /**
   * Binds the dialog's native `close` event so every close — however it is
   * triggered — emits a bubbling `loco-modal:close`, and (when a `turboFrame`
   * value is set) wires the Turbo Frame auto-open / clear-on-close behavior.
   *
   * @returns {void}
   */
  connect() {
    this.boundDispatchClose = this.dispatchClose.bind(this)
    this.element.addEventListener("close", this.boundDispatchClose)

    this.connectTurboFrame()
  }

  /**
   * Removes the native `close` listener (and any Turbo Frame listeners) to
   * avoid leaking them across reconnects.
   *
   * @returns {void}
   */
  disconnect() {
    this.element.removeEventListener("close", this.boundDispatchClose)

    this.disconnectTurboFrame()
  }

  /**
   * Opens the modal and announces it with a `loco-modal:open` event. A no-op if
   * the dialog is already open, so repeated `turbo:frame-load` events (e.g. a
   * form submit replacing the frame) never re-call `showModal()` or re-dispatch.
   *
   * @returns {void}
   */
  open() {
    if (this.element.open) return

    this.element.showModal()
    this.dispatch("open")
  }

  /**
   * Closes the modal. The resulting native `close` event triggers
   * `loco-modal:close` via {@link dispatchClose}.
   *
   * @returns {void}
   */
  close() {
    this.element.close()
  }

  /**
   * Re-dispatches the dialog's non-bubbling native `close` event as a bubbling
   * `loco-modal:close` so ancestors and document-level listeners can react.
   *
   * @returns {void}
   */
  dispatchClose() {
    this.dispatch("close")
  }

  /**
   * Global Modal + Turbo Frame wiring. When a `turboFrame` value is set, opens
   * the dialog as soon as that frame finishes loading remote content and
   * empties the frame on close so reopening refetches instead of flashing the
   * previous load. Inert (and harmless) when no frame is configured or found.
   *
   * @returns {void}
   */
  connectTurboFrame() {
    if (!this.hasTurboFrameValue) return

    this.frame = document.getElementById(this.turboFrameValue)
    if (!this.frame) return

    this.boundOpen = this.open.bind(this)
    this.boundClearFrame = this.clearFrame.bind(this)
    this.frame.addEventListener("turbo:frame-load", this.boundOpen)
    this.element.addEventListener("close", this.boundClearFrame)
  }

  /**
   * Removes the Turbo Frame listeners added in {@link connectTurboFrame}.
   *
   * @returns {void}
   */
  disconnectTurboFrame() {
    if (!this.frame) return

    this.frame.removeEventListener("turbo:frame-load", this.boundOpen)
    this.element.removeEventListener("close", this.boundClearFrame)
  }

  /**
   * Empties the configured Turbo Frame so the next visit refetches fresh
   * content instead of showing the previous load.
   *
   * @returns {void}
   */
  clearFrame() {
    if (!this.frame) return

    this.frame.removeAttribute("complete")
    this.frame.removeAttribute("src")
    this.frame.innerHTML = ""
  }
}
