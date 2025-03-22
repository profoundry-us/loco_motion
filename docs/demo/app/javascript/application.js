// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

window.visitDoc = function(path) {
  Turbo.visit(path);
  document.getElementById('al-search-modal').close()
}

window.showDocSearch = function() {
  document.getElementById('al-search-modal').showModal();
  document.getElementById('al-searchbox').querySelector('input').focus();
}

// Import InstantSearch.js
import { liteClient as algoliasearch } from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import { connectHits } from 'instantsearch.js/es/connectors'
import { configure, searchBox, hits, poweredBy } from 'instantsearch.js/es/widgets';

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
  "my-2 p-4 flex md:flex-row gap-2 items-center",
  "bg-base-200 text-base-content rounded-lg cursor-pointer",
  "hover:bg-info hover:text-white",
  "[&:hover_.ais-Snippet-highlighted]:text-white!",
  "[&:hover_.ais-Snippet-highlighted]:bg-info-content/30!",
  "[&:hover_.ais-Highlight-highlighted]:text-white!",
  "[&:hover_.ais-Highlight-highlighted]:bg-info-content/30!",
].join(" ");

const componentTemplate = (hit) => {
  return `
    <a href="javascript:visitDoc('${hit.example_path || ''}')" class="w-full ${shared_css}">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6.429 9.75 2.25 12l4.179 2.25m0-4.5 5.571 3 5.571-3m-11.142 0L2.25 7.5 12 2.25l9.75 5.25-4.179 2.25m0 0L21.75 12l-4.179 2.25m0 0 4.179 2.25L12 21.75 2.25 16.5l4.179-2.25m11.142 0-5.571 3-5.571-3" />
      </svg>
      <span class="font-bold whitespace-nowrap">${instantsearch.highlight({ attribute: 'title', hit })}</span>
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14" />
      </svg>
      <span class="flex-1 italic truncate">${hit.description || "All Examples"}</span>
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
        <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
      </svg>
    </a>
  `;
};

const exampleTemplate = (hit) => {
  return `
    <div class="flex flex-row shrink items-center gap-2 w-full">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="ml-4 size-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="m16.49 12 3.75 3.75m0 0-3.75 3.75m3.75-3.75H3.74V4.499" />
      </svg>
      <a href="javascript:visitDoc('${hit.example_path || ''}${ hit.anchor ? '#' + hit.anchor : ''}')" class="flex-1 min-w-0 ${shared_css}">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 8.25h15m-16.5 7.5h15m-1.8-13.5-3.9 19.5m-2.1-19.5-3.9 19.5" />
        </svg>
        <span class="font-bold whitespace-nowrap">${instantsearch.highlight({ attribute: 'title', hit })}</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14" />
        </svg>
        <span class="flex-1 italic truncate">${hit.description || "All Examples"}</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
          <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
        </svg>
      </a>
    </div>
  `;
};

const customGroupedHits = connectHits((renderOptions, isFirstRender) => {
  const { hits, widgetParams } = renderOptions;

  // Group hits by section
  const grouped = hits.reduce((groups, hit) => {
    const group = hit.component_name || 'Other';
    if (!groups[group]) groups[group] = [];
    groups[group].push(hit);
    return groups;
  }, {});

  widgetParams.container.innerHTML = Object.entries(grouped)
    .map(([section, hits]) => {
      return `
        <div class="group p-3 mb-3">
          <h2 class="text-xl font-bold mb-3">${section}</h2>
          ${hits.map(hit => `${hit.type == "example" ? exampleTemplate(hit) : componentTemplate(hit)}`).join('')}
        </div>
      `
    })
    .join('');
});

search.addWidgets([
  configure({
    attributesToSnippet: ["description", "code"]
  }),

  searchBox({
    container: "#al-searchbox"
  }),

  customGroupedHits({
    container: document.querySelector('#al-hits'),
  }),

  poweredBy({
    container: "#al-poweredby",
    cssClasses: { root: "justify-end" },
  }),
])

/*
search.addWidgets([
  configure({
    attributesToSnippet: ["description", "code"]
  }),

  searchBox({
    container: "#al-searchbox"
  }),

  poweredBy({
    container: "#al-poweredby",
    cssClasses: { root: "justify-end" },
  }),

  hits({
    container: "#al-hits",

    cssClasses: {
      item: "w-full p-0!"
    },

    templates: {
      item(hit, { html, components }) {
        const shared_css = "w-full p-4 space-y-2 cursor-pointer hover:bg-base-200"

        if (hit.type == "example") {
          return html`
            <a href="javascript:visitDoc('${hit.example_path}#${hit.anchor}')" class="border-l-2 border-accent ${shared_css}">
              <h2 class="font-bold text-2xl">${components.Highlight({ attribute: 'title', hit })}</h2>
              <p class="italic">${components.Snippet({ attribute: 'description', hit })}</p>
              <p class="italic text-sm">${hit.example_path}</p>
            </a>
          `
        }

        // TODO:
        //
        //  1. [x] Fix padding around items
        //  2. [ ] Make them stand out a bit more when highlighted
        //  3. [ ] Extract functionality into a stimulus controller
        //  4. [x] Add Algolia logo to ensure compliance
        //  5. [x] Write a JSON generator or Ruby API to send the proper data to Algolia
        //  6. [ ] See if we can utilize the pre-built docsearch if we send better data
        return html`
          <a href="javascript:visitDoc('${hit.example_path}')" class="${shared_css}">
            <h2 class="font-bold text-2xl">${components.Highlight({ attribute: 'title', hit })}</h2>
            <p class="italic">${components.Snippet({ attribute: 'description', hit })}</p>
            <p class="italic text-sm">${hit.example_path}</p>
          </a>
        `;
      },
    }
  })
]);
*/

search.start();
