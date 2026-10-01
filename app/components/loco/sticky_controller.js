import { Controller } from "@hotwired/stimulus"

/**
 * Sticky Controller
 *
 * Stamps `data-stuck="<edges>"` on a `position: sticky` element while it is
 * actually pinned, so loco.css's `stuck:` variants (`stuck:py-1`,
 * `group-stuck/nav:top-12`, ...) can style it. The value lists the pinned
 * edges, mirroring the `scroll-state(stuck: top)` vocabulary.
 *
 *   %nav.sticky.top-16.py-4.stuck:py-1{ data: { controller: "loco-sticky" } }
 *   %th.sticky.left-0{ data: { controller: "loco-sticky", loco_sticky_edge_value: "left" } }
 *
 * Values:
 *   edge — the pinned edge(s), space-separated: "top" (default), "bottom",
 *          "left", "right", or a combination such as "top left" for a
 *          spreadsheet corner cell.
 *
 * Detection is one IntersectionObserver per watched edge, observing the
 * element itself with a `rootMargin` that collapses the root to a 1px line at
 * the element's sticky offset (`top-16` → the line sits 4rem below the root's
 * top). A sticky element sits exactly on that line while pinned and is past it
 * while in normal flow, so "intersects the line" is "is stuck" — exact to the
 * pixel, independent of the element's height, and with no scroll listener.
 * IntersectionObserver reports on `observe()`, so a page loaded mid-scroll is
 * stamped immediately.
 *
 * Nothing is inserted into the DOM. A sentinel element was the obvious
 * alternative, but an absolutely positioned one is anchored outside any
 * scroll container that is not itself positioned (so it neither scrolls with
 * the pane nor sits in the observer root's containing-block chain), and an
 * in-flow one disturbs flex `gap` and grid tracks. Observing the element
 * avoids all of that: a sticky element keeps its normal containing block.
 *
 * The root is the nearest scrollable ancestor (any `overflow` other than
 * `visible`), so sticky headers inside `overflow-auto` panes work without
 * being told. The line is recomputed on window resize.
 */
export default class extends Controller {
  static values = {
    edge: { type: String, default: "top" }
  }

  connect() {
    this.edges = this.edgeValue.split(/\s+/).filter(Boolean)
    this.stuckEdges = new Set()
    this.observers = []
    this.realign = this.realign.bind(this)

    this.observe()
    window.addEventListener("resize", this.realign)
  }

  disconnect() {
    window.removeEventListener("resize", this.realign)
    cancelAnimationFrame(this.realignFrame)

    for (const observer of this.observers) observer.disconnect()

    this.observers = []
    this.stuckEdges.clear()
    delete this.element.dataset.stuck
  }

  edgeValueChanged() {
    if (!this.observers) return

    this.disconnect()
    this.connect()
  }

  observe() {
    for (const observer of this.observers) observer.disconnect()

    const root = this.scrollRoot()
    const size = this.rootSize(root)
    const offsets = getComputedStyle(this.element)

    this.observers = this.edges.map((edge) => {
      const observer = new IntersectionObserver(
        (entries) => this.handleEntries(edge, entries),
        { root, rootMargin: this.lineMargin(edge, offsets, size), threshold: 0 }
      )

      observer.observe(this.element)

      return observer
    })
  }

  realign() {
    cancelAnimationFrame(this.realignFrame)
    this.realignFrame = requestAnimationFrame(() => this.observe())
  }

  // Shrinks the root to a 1px line along `edge`, offset by the element's own
  // sticky inset on that side (`top: 64px` → the line is 64px below the root's
  // top edge). Negative margins pull the opposite side in to meet it.
  lineMargin(edge, offsets, { width, height }) {
    const inset = parseFloat(offsets[edge]) || 0
    const across = (length) => -Math.max(0, length - inset - 1)

    switch (edge) {
      case "bottom": return `${across(height)}px 0px ${-inset}px 0px`
      case "left": return `0px ${across(width)}px 0px ${-inset}px`
      case "right": return `0px ${-inset}px 0px ${across(width)}px`
      default: return `${-inset}px 0px ${across(height)}px 0px`
    }
  }

  // The root's scrollport — `clientWidth` / `clientHeight` exclude scrollbars,
  // which is what IntersectionObserver measures its root by.
  rootSize(root) {
    const box = root || document.documentElement

    return { width: box.clientWidth, height: box.clientHeight }
  }

  scrollRoot() {
    let node = this.element.parentElement

    while (node && node !== document.body && node !== document.documentElement) {
      const { overflow, overflowX, overflowY } = getComputedStyle(node)

      if (/(auto|scroll|hidden)/.test(`${overflow} ${overflowX} ${overflowY}`)) {
        return node
      }

      node = node.parentElement
    }

    return null
  }

  handleEntries(edge, entries) {
    const latest = entries[entries.length - 1]

    if (latest.isIntersecting) {
      this.stuckEdges.add(edge)
    } else {
      this.stuckEdges.delete(edge)
    }

    this.render()
  }

  render() {
    const value = this.edges.filter((edge) => this.stuckEdges.has(edge)).join(" ")

    if (value) {
      if (this.element.dataset.stuck !== value) this.element.dataset.stuck = value
    } else if ("stuck" in this.element.dataset) {
      delete this.element.dataset.stuck
    }
  }
}
