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
 */
export default class extends Controller {
  /**
   * Binds the dialog's native `close` event so every close — however it is
   * triggered — emits a bubbling `loco-modal:close`.
   *
   * @returns {void}
   */
  connect() {
    this.boundDispatchClose = this.dispatchClose.bind(this)
    this.element.addEventListener("close", this.boundDispatchClose)
  }

  /**
   * Removes the native `close` listener to avoid leaking it across reconnects.
   *
   * @returns {void}
   */
  disconnect() {
    this.element.removeEventListener("close", this.boundDispatchClose)
  }

  /**
   * Opens the modal and announces it with a `loco-modal:open` event.
   *
   * @returns {void}
   */
  open() {
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
}
