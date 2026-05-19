import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert-demo"
export default class AlertDemoController extends Controller {
  static targets = ["alert"]
  static values = {
    clickCount: { type: Number, default: 0 }
  }

  celebrate() {
    // Stop at 100 clicks
    if (this.clickCountValue >= 100) {
      return
    }

    this.clickCountValue++

    const messages = [
      "🎉 Nice click!",
      "✨ Keep going!",
      "🚀 You're on fire!",
      "🌟 Amazing!",
      "💪 You're a clicking machine!",
      "🎊 Party time!",
      "🏆 Champion clicker!",
    ]

    const emojis = ["🎉", "✨", "🚀", "🌟", "💪", "🎊", "🏆", "💖", "🌈", "⭐"]

    const message = messages[Math.floor(Math.random() * messages.length)]
    const emoji = emojis[Math.floor(Math.random() * emojis.length)]

    if (this.clickCountValue === 100) {
      // Special 100 clicks celebration
      this.alertTarget.innerHTML = `🎉🎊🎉 LEGENDARY! You reached 100 clicks! 🏆👑🎉🎊🎉`
      this.alertTarget.classList.add('animate-pulse')
      // Make it rainbow colored
      this.alertTarget.style.background = 'linear-gradient(90deg, #ff0000, #ff7f00, #ffff00, #00ff00, #0000ff, #4b0082, #8f00ff)'
      this.alertTarget.style.backgroundSize = '400% 400%'
      this.alertTarget.style.animation = 'rainbow 3s ease infinite'
    } else {
      this.alertTarget.innerHTML = `${message} ${emoji} (${this.clickCountValue} clicks)`

      // Add a fun animation class
      this.alertTarget.classList.add('animate-bounce')
      setTimeout(() => {
        this.alertTarget.classList.remove('animate-bounce')
      }, 500)
    }
  }
}
