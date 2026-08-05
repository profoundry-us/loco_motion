/**
 * Tabs Controller
 *
 * A Stimulus controller that drives JavaScript-powered tab switching for the
 * TabsComponent, following the ARIA tabs pattern:
 *
 *   - The active tab carries the active class (default `tab-active`) AND
 *     `aria-selected="true"`. DaisyUI styles both as the active state —
 *     including which panel is displayed — so they must stay in sync.
 *   - A roving tabindex keeps the tablist a single Tab stop; Left/Right
 *     arrows move between and activate tabs (with wrap-around), and
 *     Home/End jump to the first/last tab.
 *
 * The TabsComponent wires this controller automatically for tabs that have
 * a content panel but no `href` — no manual setup required beyond
 * registering the controller:
 *
 *   import { TabsController } from "@profoundry-us/loco_motion"
 *   application.register("loco-tabs", TabsController)
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab"]
  static values = {
    activeClass: { type: String, default: "tab-active" }
  }

  /**
   * Establishes the roving tabindex from the server-rendered active state.
   */
  connect() {
    this.tabTargets.forEach((tab) => {
      const active = tab.classList.contains(this.activeClassValue)
      tab.setAttribute("tabindex", active ? "0" : "-1")
    })
  }

  /**
   * Activates the clicked tab.
   *
   * @param {Event} event - The triggering click event
   */
  activate(event) {
    this.select(event.target.closest("[role='tab']"))
  }

  /**
   * Activates the next tab, wrapping to the first.
   *
   * @param {Event} event - The triggering keydown event
   */
  activateNext(event) {
    this.step(event, 1)
  }

  /**
   * Activates the previous tab, wrapping to the last.
   *
   * @param {Event} event - The triggering keydown event
   */
  activatePrevious(event) {
    this.step(event, -1)
  }

  /**
   * Activates the first tab.
   *
   * @param {Event} event - The triggering keydown event
   */
  activateFirst(event) {
    this.jump(event, 0)
  }

  /**
   * Activates the last tab.
   *
   * @param {Event} event - The triggering keydown event
   */
  activateLast(event) {
    this.jump(event, this.tabTargets.length - 1)
  }

  /**
   * Activates the tab `delta` positions away from the event's tab (wrapping)
   * and moves focus to it, so arrow keys both navigate and select.
   *
   * @param {Event} event - The triggering keydown event
   * @param {number} delta - How many positions to move (+1 / -1)
   */
  step(event, delta) {
    const current = event.target.closest("[role='tab']")
    const index = this.tabTargets.indexOf(current)

    if (index === -1) return

    const count = this.tabTargets.length
    const next = this.tabTargets[(index + delta + count) % count]

    this.select(next)
    next.focus()

    event.preventDefault()
  }

  /**
   * Activates the tab at the given index and moves focus to it.
   *
   * @param {Event} event - The triggering keydown event
   * @param {number} index - The tab index to activate
   */
  jump(event, index) {
    const tab = this.tabTargets[index]

    if (!tab) return

    this.select(tab)
    tab.focus()

    event.preventDefault()
  }

  /**
   * Marks the given tab as the single active tab: active class,
   * `aria-selected="true"`, and the roving `tabindex="0"`.
   *
   * @param {HTMLElement} tab - The tab element to activate
   */
  select(tab) {
    if (!tab) return

    this.clear()

    tab.classList.add(this.activeClassValue)
    tab.setAttribute("aria-selected", "true")
    tab.setAttribute("tabindex", "0")
  }

  /**
   * Deactivates every tab: removes the active class, sets
   * `aria-selected="false"`, and removes each tab from the Tab order.
   */
  clear() {
    this.tabTargets.forEach((tab) => {
      tab.classList.remove(this.activeClassValue)
      tab.setAttribute("aria-selected", "false")
      tab.setAttribute("tabindex", "-1")
    })
  }
}
