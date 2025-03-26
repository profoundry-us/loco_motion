import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const theme = this.getCurrentTheme()
    const input = this.element.querySelector(`input[value='${theme}']`);

    input.checked = true;
  }

  setTheme(event) {
    const input = event.currentTarget.querySelector('input')
    input.checked = true;

    localStorage.setItem("savedTheme", input.value)

    event.preventDefault();
  }

  getCurrentTheme() {
    const savedTheme = localStorage.getItem('savedTheme')

    if (savedTheme) {
      return savedTheme
    }

    const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    return isDarkMode ? 'dark' : 'light'
  }
}
