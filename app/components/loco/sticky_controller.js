import { Controller } from "@hotwired/stimulus"

// Sub-pixel tolerance when comparing layout positions.
const EPSILON = 0.5

/**
 * Sticky Controller
 *
 * Stamps `data-stuck="<edges>"` on a `position: sticky` element while its
 * sticky offset is actually displacing it (what `scroll-state(stuck: top)`
 * means), so loco.css's `stuck:` variants (`stuck:py-1`,
 * `stuck-left:border-r`, ...) can style it. A `top-0` bar resting at the top
 * of the page is not stuck until the content under it scrolls.
 *
 *   %nav.sticky.top-16.py-4.stuck:py-1{ data: { controller: "loco-sticky" } }
 *   %th.sticky.left-0{ data: { controller: "loco-sticky", loco_sticky_edge_value: "left" } }
 *
 * Values:
 *   edge — the pinned edge(s), space-separated: "top" (default), "bottom",
 *          "left", "right", or e.g. "top left" for a corner cell.
 *
 * Detection compares where the element is with where it would be in normal
 * flow: its offset inside its parent, measured with sticky briefly switched
 * off, carried along by the parent's live position. Pinned to the top means
 * pushed below that in-flow position, and so on per edge. Nothing is compared
 * against the offset itself, so an offset that changes (a heading's
 * `top-16 group-has-[...]:top-12`) or a layout that shifts above the element
 * (a navbar animating its height) cannot leave a stale state behind.
 *
 * The check runs on a passive, frame-throttled scroll listener attached only
 * while an IntersectionObserver reports the element visible in its scroller;
 * off-screen elements cost nothing and are never stuck. The observer reports
 * on `observe()`, so a page loaded mid-scroll is stamped at once.
 *
 * Nothing is inserted into the DOM: an absolutely positioned sentinel misses
 * scrollers that are not themselves positioned, and an in-flow one disturbs
 * flex `gap`, grid tracks, and table rows. The root is the nearest scrollable
 * ancestor, so headers inside `overflow-auto` panes work without being told.
 */
export default class extends Controller {
  static values = {
    edge: { type: String, default: "top" }
  }

  connect() {
    this.edges = this.edgeValue.split(/\s+/).filter(Boolean)
    this.realign = this.realign.bind(this)
    this.scrolled = this.scrolled.bind(this)

    this.root = this.scrollRoot()
    this.reference = this.referenceBox()
    this.rest = this.measureRest()

    this.observer = new IntersectionObserver((entries) => this.handleEntries(entries), { root: this.root })
    this.observer.observe(this.element)

    // Re-measure when the window, the scroller, or content above the element
    // resizes.
    window.addEventListener("resize", this.realign)
    this.resizeObserver = new ResizeObserver(this.realign)
    this.resizeObserver.observe(this.reference)
    if (this.root) this.resizeObserver.observe(this.root)
  }

  disconnect() {
    window.removeEventListener("resize", this.realign)
    this.resizeObserver?.disconnect()
    this.observer?.disconnect()
    this.listen(false)
    cancelAnimationFrame(this.frame)
    this.frame = null
    this.visible = false
    delete this.element.dataset.stuck
  }

  edgeValueChanged() {
    if (!this.observer) return

    this.disconnect()
    this.connect()
  }

  realign() {
    this.stale = true
    this.scrolled()
  }

  // Coalesces scrolls and re-measures into one check per animation frame.
  scrolled() {
    if (this.frame) return

    this.frame = requestAnimationFrame(() => {
      this.frame = null

      if (this.stale) {
        this.stale = false
        this.rest = this.measureRest()
      }

      this.render()
    })
  }

  scrollRoot() {
    for (let node = this.element.parentElement; node && node !== document.body; node = node.parentElement) {
      const { overflow, overflowX, overflowY } = getComputedStyle(node)

      if (/(auto|scroll|hidden)/.test(`${overflow} ${overflowX} ${overflowY}`)) return node
    }

    return null
  }

  // The nearest ancestor that generates a box, so it has a position to
  // measure the element's in-flow offset against.
  referenceBox() {
    let node = this.element.parentElement

    while (node.parentElement && getComputedStyle(node).display === "contents") {
      node = node.parentElement
    }

    return node
  }

  // The element's in-flow offset inside its reference box, read with sticky
  // switched off for one synchronous layout. Static and sticky take the same
  // flow space, so nothing else moves and nothing is painted in between.
  measureRest() {
    const { style } = this.element
    const inline = style.cssText

    style.setProperty("position", "static", "important")

    const box = this.element.getBoundingClientRect()
    const reference = this.referenceOrigin()

    style.cssText = inline

    return { top: box.top - reference.top, left: box.left - reference.left }
  }

  // The reference box's origin in viewport coordinates. A reference that IS
  // the scroller stays put while its content scrolls, so back the scroll out.
  referenceOrigin() {
    const rect = this.reference.getBoundingClientRect()

    if (this.reference !== this.root) return { top: rect.top, left: rect.left }

    return { top: rect.top - this.root.scrollTop, left: rect.left - this.root.scrollLeft }
  }

  // The watched edges along which sticky positioning is currently pushing the
  // element away from its in-flow position.
  displacedEdges() {
    const origin = this.referenceOrigin()
    const box = this.element.getBoundingClientRect()
    const down = box.top - (origin.top + this.rest.top)
    const right = box.left - (origin.left + this.rest.left)
    const shift = { top: down, bottom: -down, left: right, right: -right }

    return this.edges.filter((edge) => shift[edge] > EPSILON)
  }

  handleEntries(entries) {
    this.visible = entries[entries.length - 1].isIntersecting
    this.listen(this.visible)
    this.render()
  }

  listen(on) {
    if (on && !this.listening) {
      this.listening = this.root || window
      this.listening.addEventListener("scroll", this.scrolled, { passive: true })
    } else if (!on && this.listening) {
      this.listening.removeEventListener("scroll", this.scrolled)
      this.listening = null
    }
  }

  render() {
    const value = this.visible ? this.displacedEdges().join(" ") : ""

    if (value) {
      if (this.element.dataset.stuck !== value) this.element.dataset.stuck = value
    } else if ("stuck" in this.element.dataset) {
      delete this.element.dataset.stuck
    }
  }
}
