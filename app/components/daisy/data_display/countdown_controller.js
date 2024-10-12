import { Controller } from "@hotwired/stimulus"

console.log("CountdownController loaded!")

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds"]

  connect() {
    console.log("CountdownController#connected")

    this.days = this.getPartValue("days")
    this.hours = this.getPartValue("hours")
    this.minutes = this.getPartValue("minutes")
    this.seconds = this.getPartValue("seconds")

    this.initialSeconds =
      this.days * 24 * 60 * 60 +
      this.hours * 60 * 60 +
      this.minutes * 60 +
      this.seconds

    this.totalSeconds = this.initialSeconds

    this.startCountdown()
    console.log("Countdown Settings: ", this.days, this.hours, this.minutes, this.seconds, this.totalSeconds)
  }

  getPartValue(part) {
    let target = null

    switch (part) {
      case "days":
        target = this.hasDaysTarget ? this.daysTarget : null
        break
      case "hours":
        target = this.hasHoursTarget ? this.hoursTarget : null
        break
      case "minutes":
        target = this.hasMinutesTarget ? this.minutesTarget : null
        break
      case "seconds":
        target = this.hasSecondsTarget ? this.secondsTarget : null
        break
    }

    return target?.querySelector("span")?.style?.getPropertyValue("--value") || 0
  }

  startCountdown() {
    this.interval = setInterval(() => {
      this.totalSeconds--

      if (this.totalSeconds <= 0) {
        clearInterval(this.interval)
      }

      this.updateCountdown()
    }, 1000)
  }

  updateCountdown() {
    let days = Math.floor(this.totalSeconds / (60 * 60 * 24))
    let hours = Math.floor((this.totalSeconds % (60 * 60 * 24)) / (60 * 60))
    let minutes = Math.floor((this.totalSeconds % (60 * 60)) / 60)
    let seconds = Math.floor(this.totalSeconds % 60)

    if (this.hasDaysTarget) {
      this.daysTarget?.querySelector("span")?.style?.setProperty("--value", days)
    }

    if (this.hasHoursTarget) {
      this.hoursTarget?.querySelector("span")?.style?.setProperty("--value", hours)
    }

    if (this.hasMinutesTarget) {
      this.minutesTarget?.querySelector("span")?.style?.setProperty("--value", minutes)
    }

    if (this.hasSecondsTarget) {
      this.secondsTarget?.querySelector("span")?.style?.setProperty("--value", seconds)
    }
  }
}
