// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Import Algolia search functionality
import "./algolia_search"

// Import third-party libraries we use
import "cally"

console.log('refresh document')
document.addEventListener('turbo:load', (event) => console.log(` !!! load`, event.detail))
document.addEventListener('turbo:visit', (event) => console.log(` !!! visit`, event.detail.action))
document.addEventListener('turbo:before-fetch-request', (event) => console.log(` !!! before fetch request`, event.detail))
document.addEventListener('turbo:morph', () => console.log(' !!! morph render'))
document.addEventListener('turbo:before-render', () => console.log(' !!! before render'))
document.addEventListener('turbo:before-frame-render', () => console.log(' !!! before frame render'))
document.addEventListener('turbo:frame-render', () => console.log(' !!! frame render'))
document.addEventListener('turbo:before-stream-render', (event) => console.log(` !!! stream render (${event.target.getAttribute('action')} event)`, event.target))
