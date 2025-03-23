// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Import InstantSearch.js
import { liteClient as algoliasearch } from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import { connectHits } from 'instantsearch.js/es/connectors'
import { configure, searchBox, stats, poweredBy } from 'instantsearch.js/es/widgets';

window.visitDoc = function(path) {
  Turbo.visit(path);
  document.getElementById('al-search-modal').close()
}

window.showDocSearch = function() {
  document.getElementById('al-search-modal').showModal();
  document.getElementById('al-searchbox').querySelector('input').focus();
}

// Handle up/down arrow navigation in the search results
window.handleSearchResultsNavigation = function(event) {
  const modal = document.getElementById('al-search-modal');
  const isOpen = modal && modal.open;

  // Only handle keyboard navigation if the modal is open
  if (!isOpen) return;

  const hits = document.querySelectorAll('#al-hits a');
  if (hits.length === 0) return;

  // Find the currently focused element index
  let currentIndex = -1;
  for (let i = 0; i < hits.length; i++) {
    if (document.activeElement === hits[i]) {
      currentIndex = i;
      break;
    }
  }

  // Handle arrow key navigation
  if (event.key === 'ArrowDown') {
    event.preventDefault();
    // Select the first item if none is selected, or move to the next
    const nextIndex = currentIndex === -1 || currentIndex === hits.length - 1 ? 0 : currentIndex + 1;
    hits[nextIndex].focus();
  } else if (event.key === 'ArrowUp') {
    event.preventDefault();
    // Select the last item if none is selected, or move to the previous
    const prevIndex = currentIndex === -1 || currentIndex === 0 ? hits.length - 1 : currentIndex - 1;
    hits[prevIndex].focus();
  } else if (event.key === 'Enter' && currentIndex !== -1) {
    // Execute the link if Enter is pressed
    event.preventDefault();
    hits[currentIndex].click();
  }
}

// Add keyboard shortcut for search (Cmd+K on Mac, Ctrl+K on Windows/Linux)
document.addEventListener('keydown', function(event) {
  // Check if the key is 'k' and either Cmd (Mac) or Ctrl (Windows/Linux) is pressed
  if (event.key === 'k' && (event.metaKey || event.ctrlKey)) {
    event.preventDefault(); // Prevent the browser's default behavior
    showDocSearch();
  } else {
    // Handle arrow key navigation in search results
    handleSearchResultsNavigation(event);
  }
});

/*
  Initialize the search client

  If you're logged into the Algolia dashboard, the following values for
  YourApplicationID and YourSearchOnlyAPIKey are auto-selected from
  the currently selected Algolia application.
*/
const searchClient = algoliasearch('NEWSB29XIB', '6564437329147da01e34fe5c94c4508e');

// Render the InstantSearch.js wrapper
// Replace INDEX_NAME with the name of your index.
const search = instantsearch({
  indexName: 'loco_motion_development_components',
  searchClient,
});

const shared_css = [
  "my-2 p-3 flex md:flex-row gap-2 items-center",
  "bg-base-100 text-base-content rounded-lg shadow-sm cursor-pointer",
  "hover:bg-secondary hover:text-white",
  "focus:bg-secondary focus:text-white",
  "focus:outline-none",
  "[&_.ais-Snippet-highlighted]:bg-secondary/80! [&_.ais-Snippet-highlighted]:text-white!",
  "[&:focus_.ais-Snippet-highlighted]:bg-black/80! [&:focus_.ais-Snippet-highlighted]:text-white!",
  "[&:hover_.ais-Snippet-highlighted]:bg-black/80! [&:hover_.ais-Snippet-highlighted]:text-white!",
  "[&_.ais-Highlight-highlighted]:bg-secondary/80! [&_.ais-Highlight-highlighted]:text-white!",
  "[&:focus_.ais-Highlight-highlighted]:bg-black/80! [&:focus_.ais-Highlight-highlighted]:text-white!",
  "[&:hover_.ais-Highlight-highlighted]:bg-black/80! [&:hover_.ais-Highlight-highlighted]:text-white!",
].join(" ");

const componentIcon = `
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
    <path stroke-linecap="round" stroke-linejoin="round" d="M6.429 9.75 2.25 12l4.179 2.25m0-4.5 5.571 3 5.571-3m-11.142 0L2.25 7.5 12 2.25l9.75 5.25-4.179 2.25m0 0L21.75 12l-4.179 2.25m0 0 4.179 2.25L12 21.75 2.25 16.5l4.179-2.25m11.142 0-5.571 3-5.571-3" />
  </svg>
`;

const dashIcon = `
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
    <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14" />
  </svg>
`;

const arrowIcon = `
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
    <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
  </svg>
`;

const insetIcon = `
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="ml-4 size-6">
    <path stroke-linecap="round" stroke-linejoin="round" d="m16.49 12 3.75 3.75m0 0-3.75 3.75m3.75-3.75H3.74V4.499" />
  </svg>
`;

const exampleIcon = `
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
    <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 8.25h15m-16.5 7.5h15m-1.8-13.5-3.9 19.5m-2.1-19.5-3.9 19.5" />
  </svg>
`;

const groupTemplate = (section, hits) =>`
  <div class="group px-2 mb-6 first:mt-2">
    <h2 class="text-lg font-bold mb-2 pl-1 capitalize">${section}</h2>
    ${hits.map(hit => `${hit.type == "example" ? exampleTemplate(hit) : componentTemplate(hit)}`).join('')}
  </div>
`;

const componentTemplate = (hit) => {
  return `
    <a href="javascript:visitDoc('${hit.example_path || ''}')" class="w-full ${shared_css}">
      ${componentIcon}
      <span class="whitespace-nowrap">${instantsearch.highlight({ attribute: 'title', hit })}</span>
      ${dashIcon}
      <span class="flex-1 italic truncate">${instantsearch.highlight({ attribute: 'description', hit }) || "All Examples"}</span>
      ${arrowIcon}
    </a>
  `;
};

const exampleTemplate = (hit) => {
  return `
    <div class="flex flex-row shrink items-center gap-2 w-full">
      ${insetIcon}
      <a href="javascript:visitDoc('${hit.example_path || ''}${ hit.anchor ? '#' + hit.anchor : ''}')" class="flex-1 min-w-0 ${shared_css}">
        ${exampleIcon}
        <span class="whitespace-nowrap">${instantsearch.highlight({ attribute: 'title', hit })}</span>
        ${dashIcon}
        <span class="flex-1 italic truncate">${instantsearch.highlight({ attribute: 'description', hit }) || "No description..."}</span>
        ${arrowIcon}
      </a>
    </div>
  `;
};

const customGroupedHits = connectHits((renderOptions, isFirstRender) => {
  const { hits, widgetParams } = renderOptions;

  // Group hits by section
  const grouped = hits.reduce((groups, hit) => {
    const group = hit.section ? (hit.framework + " " + hit.section) : hit.framework;

    if (!groups[group]) groups[group] = [];

    groups[group].push(hit);

    return groups;
  }, {});

  widgetParams.container.innerHTML = Object.entries(grouped)
    .map(([section, hits]) => groupTemplate(section, hits)).join('');
});

search.addWidgets([
  configure({
    attributesToSnippet: ["description", "code"]
  }),

  searchBox({
    container: "#al-searchbox",
    autofocus: true,
    placeholder: "Search documentation",
    cssClasses: {
      form: "rounded-lg!",
      input: "bg-base-100! text-base-content! rounded-lg! focus:border-primary! caret-primary! placeholder:text-primary/60! dark:focus:border-secondary! dark:caret-secondary! dark:placeholder:text-base-content/60! dark:focus:placeholder:text-secondary/60!"
    }
  }),

  customGroupedHits({
    container: document.querySelector('#al-hits'),
  }),

  stats({
    container: document.querySelector('#al-stats'),
    cssClasses: { root: "py-6 text-center italic" }
  }),

  poweredBy({
    container: "#al-poweredby",
    cssClasses: { root: "justify-end dark:hidden!" },
  }),

  poweredBy({
    container: "#al-poweredby-dark",
    theme: 'dark',
    cssClasses: { root: "justify-end hidden! dark:block!" },
  }),
])

search.start();
