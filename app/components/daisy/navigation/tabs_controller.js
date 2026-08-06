/**
 * Tabs Controller
 *
 * A Stimulus controller that drives JavaScript-powered tab switching for the
 * TabsComponent, following the ARIA tabs pattern with **manual activation**:
 *
 *   - Left/Right arrows move focus between tabs (with wrap-around) and
 *     Home/End jump to the first/last tab — moving focus only browses; it
 *     does not select. Enter or Space (a native button click) activates the
 *     focused tab. Manual activation keeps arrow-key browsing free of side
 *     effects, which matters when panels are expensive to show.
 *   - The active tab carries the active class (default `tab-active`) AND
 *     `aria-selected="true"`. DaisyUI styles both as the active state —
 *     including which panel is displayed — so they must stay in sync.
 *   - A roving tabindex keeps the tablist a single Tab stop; it follows the
 *     most recently focused tab, per the ARIA APG manual-activation pattern.
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
    const active = this.tabTargets.find((tab) => tab.classList.contains(this.activeClassValue))

    this.rove(active || this.tabTargets[0])
  }

  /**
   * Activates the clicked (or Enter/Space-pressed) tab.
   *
   * @param {Event} event - The triggering click event
   */
  activate(event) {
    this.select(event.target.closest("[role='tab']"))
  }

  /**
   * Moves focus to the next tab, wrapping to the first. Does not select.
   *
   * @param {Event} event - The triggering keydown event
   */
  focusNext(event) {
    this.focusStep(event, 1)
  }

  /**
   * Moves focus to the previous tab, wrapping to the last. Does not select.
   *
   * @param {Event} event - The triggering keydown event
   */
  focusPrevious(event) {
    this.focusStep(event, -1)
  }

  /**
   * Moves focus to the first tab. Does not select.
   *
   * @param {Event} event - The triggering keydown event
   */
  focusFirst(event) {
    this.focusJump(event, 0)
  }

  /**
   * Moves focus to the last tab. Does not select.
   *
   * @param {Event} event - The triggering keydown event
   */
  focusLast(event) {
    this.focusJump(event, this.tabTargets.length - 1)
  }

  /**
   * Moves focus to the tab `delta` positions away (wrapping).
   *
   * @param {Event} event - The triggering keydown event
   * @param {number} delta - How many positions to move (+1 / -1)
   */
  focusStep(event, delta) {
    const current = event.target.closest("[role='tab']")
    const index = this.tabTargets.indexOf(current)

    if (index === -1) return

    const count = this.tabTargets.length

    this.focusTab(this.tabTargets[(index + delta + count) % count])
    event.preventDefault()
  }

  /**
   * Moves focus to the tab at the given index.
   *
   * @param {Event} event - The triggering keydown event
   * @param {number} index - The tab index to focus
   */
  focusJump(event, index) {
    const tab = this.tabTargets[index]

    if (!tab) return

    this.focusTab(tab)
    event.preventDefault()
  }

  /**
   * Focuses the given tab and roves the tabindex to it, so Tabbing away and
   * back returns to the tab the user was browsing.
   *
   * @param {HTMLElement} tab - The tab element to focus
   */
  focusTab(tab) {
    this.rove(tab)
    tab.focus()
  }

  /**
   * Marks the given tab as the single active tab: active class and
   * `aria-selected="true"`, with the roving tabindex on it.
   *
   * @param {HTMLElement} tab - The tab element to activate
   */
  select(tab) {
    if (!tab) return

    this.clear()

    tab.classList.add(this.activeClassValue)
    tab.setAttribute("aria-selected", "true")
    this.rove(tab)
  }

  /**
   * Deactivates every tab: removes the active class and sets
   * `aria-selected="false"`.
   */
  clear() {
    this.tabTargets.forEach((tab) => {
      tab.classList.remove(this.activeClassValue)
      tab.setAttribute("aria-selected", "false")
    })
  }

  /**
   * Makes the given tab the tablist's single Tab stop.
   *
   * @param {HTMLElement} tab - The tab element to make focusable
   */
  rove(tab) {
    if (!tab) return

    this.tabTargets.forEach((t) => {
      t.setAttribute("tabindex", t === tab ? "0" : "-1")
    })
  }
}
