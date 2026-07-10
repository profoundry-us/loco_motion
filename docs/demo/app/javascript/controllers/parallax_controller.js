import { Controller } from "@hotwired/stimulus"

// Drives the homepage's scroll choreography — "watch the components leave the
// station":
//
//   * [data-parallax-speed] elements (the hero cluster) drift, spin, and fade
//     as the page scrolls, each at its own speed/drift/rotation.
//   * [data-pop] elements (flair in the lower sections) spring into view when
//     they scroll near the viewport, and reset when they leave below.
//
// Honors `prefers-reduced-motion`: everything is settled at rest with no scroll
// loop, so the page is fully legible without any motion.
export default class extends Controller {
  static values = {
    strength: { type: Number, default: 1 },
    fade: { type: Boolean, default: true }
  }

  connect() {
    this.parallaxEls = Array.from(this.element.querySelectorAll("[data-parallax-speed]"))
    this.popEls = Array.from(this.element.querySelectorAll("[data-pop]"))

    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)")
    if (reduced.matches) {
      this.settle()
      return
    }

    this.last = -1
    this.tick = this.tick.bind(this)
    this.onScroll = () => this.apply(this.scrollTop())

    // Capture-phase listener catches scrolls on inner wrappers too; the rAF
    // loop is the primary driver and keeps things smooth on fast scrolls.
    document.addEventListener("scroll", this.onScroll, { capture: true, passive: true })
    this.tick()
  }

  disconnect() {
    if (this.raf) window.cancelAnimationFrame(this.raf)
    if (this.onScroll) document.removeEventListener("scroll", this.onScroll, true)
  }

  tick() {
    const t = this.scrollTop()
    if (t !== this.last) {
      this.last = t
      this.apply(t)
    }
    this.raf = window.requestAnimationFrame(this.tick)
  }

  // The page usually scrolls on the window, but the layout can scroll inside a
  // wrapper element — fall back to the nearest scrolled ancestor.
  scrollTop() {
    let s = window.scrollY || document.documentElement.scrollTop || document.body.scrollTop || 0
    if (!s) {
      let n = this.element
      while (n && n !== document.documentElement) {
        if (n.scrollTop > 0) { s = n.scrollTop; break }
        n = n.parentElement
      }
    }
    return s
  }

  apply(t) {
    const k = this.strengthValue
    const fade = this.fadeValue

    this.parallaxEls.forEach((el) => {
      const sp = parseFloat(el.dataset.parallaxSpeed) || 0.5
      const dr = parseFloat(el.dataset.parallaxDrift) || 0
      const rot = parseFloat(el.dataset.parallaxRot) || 0
      const spin = rot + t * dr * 0.08 * k
      el.style.transform =
        "translate3d(" + (t * dr * 1.6 * k).toFixed(1) + "px, " +
        (-t * sp * k).toFixed(1) + "px, 0) rotate(" + spin.toFixed(1) + "deg)"
      el.style.opacity = fade ? String(Math.max(0, 1 - t / 650)) : "1"
    })

    const winH = window.innerHeight
    // Flair pinned near the very bottom of the page can never cross the 85%
    // reveal line — once the scroll is exhausted, reveal anything in view.
    const atBottom = t + winH >= document.documentElement.scrollHeight - 60
    this.popEls.forEach((el) => {
      const rot = parseFloat(el.dataset.popRot) || 0
      const r = el.getBoundingClientRect()
      if ((r.top < winH * 0.85 || (atBottom && r.top < winH)) && r.bottom > 0) {
        el.style.opacity = "1"
        el.style.transform = "translateY(0) scale(1) rotate(" + rot + "deg)"
      } else if (r.top >= winH) {
        el.style.opacity = "0"
        el.style.transform = "translateY(46px) scale(.4)"
      }
    })
  }

  // Reduced-motion / no-scroll resting state: reveal everything in place.
  settle() {
    this.parallaxEls.forEach((el) => {
      const rot = parseFloat(el.dataset.parallaxRot) || 0
      el.style.opacity = "1"
      el.style.transform = "rotate(" + rot + "deg)"
    })
    this.popEls.forEach((el) => {
      const rot = parseFloat(el.dataset.popRot) || 0
      el.style.opacity = "1"
      el.style.transform = "translateY(0) scale(1) rotate(" + rot + "deg)"
    })
  }
}
