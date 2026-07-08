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

  // Linear progress bar — jump to a new random value.
  randomizeProgress(event) {
    event.currentTarget.value = Math.floor(Math.random() * 101)
  }

  // Open the documentation search modal (same entry point as the header).
  openSearch() {
    if (typeof window.showDocSearch === "function") window.showDocSearch()
  }

  // Spin the element like a prize wheel — three full turns.
  spin(event) {
    event.currentTarget.animate(
      [{ transform: "rotate(0deg)" }, { transform: "rotate(1080deg)" }],
      { duration: 900, easing: "cubic-bezier(.2,.7,.2,1)" }
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
