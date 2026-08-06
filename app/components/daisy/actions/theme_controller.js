/**
 * Theme Controller
 *
 * A Stimulus controller that manages theme selection and persistence.
 * It handles theme switching, localStorage persistence, and synchronization
 * across multiple theme selectors on the same page.
 *
 * Themes are stored per color scheme so users can keep a preferred light
 * theme AND a preferred dark theme:
 *
 *   - `savedLightTheme` / `savedDarkTheme` — the preferred theme for each
 *     scheme. A theme lands in the slot matching its own `color-scheme`
 *     declaration (every DaisyUI theme declares one).
 *   - `savedThemeMode` — how the active scheme is chosen: `"light"` or
 *     `"dark"` pin that scheme (picking a theme in a switcher pins its
 *     scheme, preserving classic single-theme behavior), while `"system"`
 *     follows the OS preference live, swapping between the two saved themes
 *     as the OS switches.
 *   - The legacy single `savedTheme` key is migrated on connect.
 *
 * Whenever a theme is applied, the active scheme is stamped on `<html>` as
 * `data-color-scheme`, which drives the `dark:` Tailwind variant shipped in
 * loco.css — so `dark:` utilities follow any dark theme, not just the one
 * named "dark".
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  /**
   * Called when the controller is connected to the DOM.
   * Migrates legacy storage, stamps the active color scheme, sets the
   * initial theme input state, and sets up event listeners.
   */
  connect() {
    this.migrateLegacyStorage()
    this.stampScheme()
    this.setInput()

    // Setup a custom listener to watch for changes on the page in case the
    // page has multiple theme selectors
    this.storageChangeListener = this.storageChanged.bind(this)
    window.addEventListener('localstorage-update', this.storageChangeListener)

    // Automatically persist + sync whenever a theme input within this
    // controller changes. This means consumers do NOT need to wire up a
    // `setTheme` action on each radio/checkbox — simply changing the input is
    // enough to save the theme and keep every other selector in sync.
    this.inputChangeListener = this.handleInputChange.bind(this)
    this.element.addEventListener('change', this.inputChangeListener)

    // In "system" mode the active theme follows the OS preference live.
    this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
    this.mediaChangeListener = this.mediaChanged.bind(this)
    this.mediaQuery.addEventListener('change', this.mediaChangeListener)
  }

  /**
   * Called when the controller is disconnected from the DOM.
   * Removes event listeners to prevent memory leaks.
   */
  disconnect() {
    window.removeEventListener('localstorage-update', this.storageChangeListener)
    this.element.removeEventListener('change', this.inputChangeListener)
    this.mediaQuery.removeEventListener('change', this.mediaChangeListener)
  }

  /**
   * Syncs the radio inputs within this controller to the current theme.
   * The input matching the active theme is checked and every other
   * theme-controller input is unchecked, so a selection made in one selector
   * never leaves a stale `:checked` input behind in another.
   */
  setInput() {
    const theme = this.getCurrentTheme()
    const inputs = this.element.querySelectorAll('input.theme-controller')

    inputs.forEach((input) => {
      input.checked = input.value === theme
    })
  }

  /**
   * Clears the user's theme preferences from localStorage.
   * Removes every saved theme key and dispatches an event to notify other
   * controllers. Also removes the `data-theme` and `data-color-scheme`
   * attributes from the document element.
   *
   * @param {Event} event - The triggering click event
   */
  clearTheme(event) {
    // If we are passed a themeName parameter, clear all inputs with that theme
    if (event && event.params && event.params.themeName) {
      const inputs = document.querySelectorAll(`input[name='${event.params.themeName}']`)

      if (inputs) {
        inputs.forEach(input => {
          input.checked = false
        })
      }
    }

    // Remove every saved theme key from local storage
    this.safeStorageRemove("savedTheme")
    this.safeStorageRemove("savedThemeMode")
    this.safeStorageRemove("savedLightTheme")
    this.safeStorageRemove("savedDarkTheme")

    // Remove the theme attributes from the document element
    document.documentElement.removeAttribute('data-theme')
    document.documentElement.removeAttribute('data-color-scheme')

    // Fire off an update
    this.broadcast(null)
  }

  /**
   * Changes the theme based on user selection.
   * Updates localStorage and dispatches a custom event to notify other controllers.
   *
   * Supports two markup patterns:
   *   1. The action is placed on a wrapper element that contains an `<input>`
   *      (e.g. the Custom Switcher's `<a>` links).
   *   2. The action is placed directly on the `<input>` itself.
   *
   * @param {Event} event - The triggering click event
   */
  setTheme(event) {
    const target = event.currentTarget
    const input = target.matches && target.matches('input')
      ? target
      : target.querySelector('input')

    if (input) {
      this.applyTheme(input.value)
    }

    event.preventDefault()
  }

  /**
   * Changes how the active color scheme is chosen. Expects a Stimulus action
   * param, e.g. `data-loco-theme-mode-param="system"`:
   *
   *   - `"light"` / `"dark"` — pin that scheme; its saved theme (or the
   *     built-in `light`/`dark` theme when none is saved) applies.
   *   - `"system"` — follow the OS preference live, swapping between the
   *     saved light and dark themes as the OS switches.
   *
   * @param {Event} event - The triggering event with a `mode` param
   */
  setMode(event) {
    const mode = event && event.params && event.params.mode

    if (!mode) return

    this.safeStorageSet('savedThemeMode', mode)
    this.applyResolvedTheme()

    if (event.preventDefault) event.preventDefault()
  }

  /**
   * Handles `change` events bubbling up from any theme-controller input within
   * this controller. Persists and broadcasts the newly selected theme so every
   * other selector stays in sync — no per-input action wiring required.
   *
   * @param {Event} event - The triggering change event
   */
  handleInputChange(event) {
    const input = event.target

    if (!input || !input.classList || !input.classList.contains('theme-controller')) return
    if (!input.checked) return

    this.applyTheme(input.value)
  }

  /**
   * Persists the given theme, applies it to the document, and notifies every
   * other theme controller on the page so they can sync their inputs.
   *
   * The theme is saved as the preference for the scheme it belongs to (read
   * from its own computed `color-scheme`), and the mode is pinned to that
   * scheme so the selection behaves like classic single-theme switching until
   * an app opts into `"system"` mode.
   *
   * @param {string} value - The theme name to apply
   */
  applyTheme(value) {
    document.documentElement.setAttribute('data-theme', value)

    const scheme = this.computedScheme()

    this.safeStorageSet(scheme === 'dark' ? 'savedDarkTheme' : 'savedLightTheme', value)
    this.safeStorageSet('savedThemeMode', scheme)
    this.safeStorageRemove('savedTheme')

    document.documentElement.setAttribute('data-color-scheme', scheme)

    this.broadcast(value)
  }

  /**
   * Resolves the active theme from the saved mode + per-scheme preferences
   * and applies it: sets `data-theme`, stamps `data-color-scheme`, and
   * broadcasts so all selectors re-sync. Used when the mode or the OS
   * preference changes.
   */
  applyResolvedTheme() {
    const resolved = this.resolveTheme()

    if (!resolved) return

    document.documentElement.setAttribute('data-theme', resolved.theme)
    document.documentElement.setAttribute('data-color-scheme', resolved.scheme)

    this.broadcast(resolved.theme)
  }

  /**
   * Resolves which theme and scheme should be active from localStorage.
   *
   * @returns {?{theme: string, scheme: string}} The resolved theme and
   *   scheme, or null when no mode is saved (no explicit choice yet)
   */
  resolveTheme() {
    const mode = this.safeStorageGet('savedThemeMode')

    if (!mode) return null

    const scheme = mode === 'system'
      ? (this.mediaQuery && this.mediaQuery.matches ? 'dark' : 'light')
      : mode
    const saved = this.safeStorageGet(scheme === 'dark' ? 'savedDarkTheme' : 'savedLightTheme')

    // With no saved preference for the scheme, fall back to the built-in
    // theme of the same name — DaisyUI always defines `light` and `dark`,
    // and downstream apps restyle those names rather than renaming them.
    return { theme: saved || scheme, scheme }
  }

  /**
   * Retrieves the current (effective) theme.
   *
   * Prefers the user's saved choice from localStorage. When nothing is saved
   * yet — e.g. on a first visit — it falls back to whatever theme is already
   * applied to the document via the `data-theme` attribute (set by a
   * server-rendered theme, the `theme_preload_script`, or another controller).
   * That way the active row / checkmark reflects the theme the user is actually
   * seeing instead of being left blank until they pick one.
   *
   * @returns {?string} The current theme name, or null if none can be determined
   */
  getCurrentTheme() {
    const resolved = this.resolveTheme()

    if (resolved) {
      return resolved.theme
    }

    return document.documentElement.getAttribute('data-theme')
  }

  /**
   * Migrates the legacy single `savedTheme` key to the per-scheme model by
   * re-applying it through `applyTheme`, which classifies the theme by its
   * own `color-scheme`, saves it into the matching slot, pins the mode, and
   * removes the legacy key.
   */
  migrateLegacyStorage() {
    const legacy = this.safeStorageGet('savedTheme')

    if (legacy && !this.safeStorageGet('savedThemeMode')) {
      this.applyTheme(legacy)
    }
  }

  /**
   * Stamps `data-color-scheme` on the document element from the active
   * theme's computed `color-scheme` when an explicit theme is applied but no
   * scheme is stamped yet (e.g. a server-rendered `data-theme`).
   */
  stampScheme() {
    const root = document.documentElement

    if (root.getAttribute('data-theme') && !root.getAttribute('data-color-scheme')) {
      root.setAttribute('data-color-scheme', this.computedScheme())
    }
  }

  /**
   * Reads the active theme's own scheme from the document element's computed
   * `color-scheme` — every DaisyUI theme declares `color-scheme: light` or
   * `color-scheme: dark`.
   *
   * @returns {string} `"dark"` or `"light"`
   */
  computedScheme() {
    const value = getComputedStyle(document.documentElement).colorScheme || ''

    return value.includes('dark') && !value.includes('light') ? 'dark' : 'light'
  }

  /**
   * Responds to OS color-scheme changes. Only relevant in `"system"` mode,
   * where the active theme swaps between the saved light and dark themes.
   */
  mediaChanged() {
    if (this.safeStorageGet('savedThemeMode') === 'system') {
      this.applyResolvedTheme()
    }
  }

  /**
   * Notifies every theme controller on the page (including this one) that
   * the theme changed so they can re-sync their inputs.
   *
   * @param {?string} value - The newly applied theme name, or null on clear
   */
  broadcast(value) {
    const updateEvent = new CustomEvent('localstorage-update', { detail: { key: 'savedTheme', newValue: value } })
    window.dispatchEvent(updateEvent)
  }

  /**
   * Safely reads a value from localStorage. Access can throw in some
   * environments (e.g. Safari private browsing), so failures are swallowed
   * and treated as if no value were saved.
   *
   * @param {string} key - The localStorage key to read
   * @returns {?string} The stored value, or null if unavailable
   */
  safeStorageGet(key) {
    try {
      return localStorage.getItem(key)
    } catch (e) {
      return null
    }
  }

  /**
   * Safely writes a value to localStorage. Access can throw in some
   * environments (e.g. Safari private browsing), so failures are swallowed
   * to avoid aborting theme application.
   *
   * @param {string} key - The localStorage key to write
   * @param {string} value - The value to store
   */
  safeStorageSet(key, value) {
    try {
      localStorage.setItem(key, value)
    } catch (e) {
      // localStorage not available (e.g., private browsing mode)
    }
  }

  /**
   * Safely removes a value from localStorage. Access can throw in some
   * environments (e.g. Safari private browsing), so failures are swallowed.
   *
   * @param {string} key - The localStorage key to remove
   */
  safeStorageRemove(key) {
    try {
      localStorage.removeItem(key)
    } catch (e) {
      // localStorage not available (e.g., private browsing mode)
    }
  }

  /**
   * Event handler for 'localstorage-update' events.
   * Updates the input state when theme changes in another controller.
   *
   * @param {CustomEvent} event - The storage changed event
   */
  storageChanged(event) {
    this.setInput()
  }
}
