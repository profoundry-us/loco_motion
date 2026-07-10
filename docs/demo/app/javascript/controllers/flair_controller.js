import { Controller } from "@hotwired/stimulus"

// Fun, interactive behaviors for the home page hero flair. Every piece of flair
// is a real, clickable LocoMotion component; these actions let visitors play
// with them. The controller is mounted once on the parallax root, so each
// action reads `event.currentTarget` to act on the specific flair that was
// clicked.
export default class extends Controller {
  // Radial progress ring — jump to a new random percentage.
  randomizeRadial(event) {
    const el = event.currentTarget
    const n = Math.floor(Math.random() * 101)
    el.style.setProperty("--value", n)
    el.setAttribute("aria-valuenow", n)
    el.textContent = `${n}%`
  }

  // Linear progress bar — scrub to the pointer's position, on click or drag.
  // Pointer capture keeps a drag updating after the pointer leaves the bar,
  // and `offsetX` maps through the flair's rotation/parallax transforms into
  // the bar's local coordinate space.
  startScrub(event) {
    this.scrubbing = true
    event.currentTarget.setPointerCapture(event.pointerId)
    this.applyScrub(event)
  }

  moveScrub(event) {
    if (this.scrubbing) this.applyScrub(event)
  }

  endScrub() {
    this.scrubbing = false
  }

  applyScrub(event) {
    const el = event.currentTarget
    const fraction = event.offsetX / el.clientWidth
    el.value = Math.round(Math.max(0, Math.min(1, fraction)) * el.max)
  }

  // Open the documentation search modal (same entry point as the header).
  openSearch() {
    if (typeof window.showDocSearch === "function") window.showDocSearch()
  }

  // Grow the element large while fading it out, then fade it back in after a
  // beat. Scale + opacity (not rotation) so the drop shadow doesn't smear.
  poof(event) {
    event.currentTarget.animate(
      [
        { transform: "scale(1)", opacity: 1, offset: 0 },
        { transform: "scale(1.9)", opacity: 0, offset: 0.3 },
        { transform: "scale(1.9)", opacity: 0, offset: 0.75 },
        { transform: "scale(1)", opacity: 1, offset: 1 }
      ],
      { duration: 1200, easing: "ease-in-out" }
    )
  }

  // Shake the element left and right.
  shake(event) {
    event.currentTarget.animate(
      [
        { transform: "translateX(0)" },
        { transform: "translateX(-6px)" },
        { transform: "translateX(6px)" },
        { transform: "translateX(-5px)" },
        { transform: "translateX(4px)" },
        { transform: "translateX(-2px)" },
        { transform: "translateX(0)" }
      ],
      { duration: 450, easing: "ease-in-out" }
    )
  }
}
