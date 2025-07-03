// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Import Algolia search functionality
import "./algolia_search"

// Import third-party libraries we use
import "cally"

document.addEventListener('turbo:load', (event) => console.debug(` !!! load`, event.detail))
document.addEventListener('turbo:visit', (event) => console.debug(` !!! visit`, event.detail.action))
document.addEventListener('turbo:before-fetch-request', (event) => console.debug(` !!! before fetch request`, event.detail))
document.addEventListener('turbo:morph', () => console.debug(' !!! morph render'))
document.addEventListener('turbo:before-render', () => console.debug(' !!! before render'))
document.addEventListener('turbo:before-frame-render', () => console.debug(' !!! before frame render'))
document.addEventListener('turbo:frame-render', () => console.debug(' !!! frame render'))
document.addEventListener('turbo:before-stream-render', (event) => console.debug(` !!! stream render (${event.target.getAttribute('action')} event)`, event.target))
