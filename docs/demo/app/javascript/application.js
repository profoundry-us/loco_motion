// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

function truncateString(str, num, ending = '...') {
  return str.length > num ? str.slice(0, num) + ending : str;
}

window.visitDoc = function(path) {
  Turbo.visit(path);
  document.getElementById('al-search-modal').close()
}

// Import InstantSearch.js
import { liteClient as algoliasearch } from 'algoliasearch/lite';
import instantsearch from 'instantsearch.js';
import { searchBox, hits } from 'instantsearch.js/es/widgets';

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
  indexName: 'loco_motion_demo_staging_profoundry_us_newsb29xib_pages',
  searchClient,
});

search.addWidgets([
  searchBox({
    container: "#al-searchbox"
  }),

  hits({
    container: "#al-hits",

    transformItems(items) {
      return items.map(item => ({
        ...item,
        description: truncateString(item.content, 50),
      }));
    },

    templates: {
      item(hit, { html, components }) {

        // TODO:
        //
        //  1. Fix padding around items
        //  2. Make them stand out a bit more when highlighted
        //  3. Extract functionality into a stimulus controller
        return html`
          <a href="javascript:visitDoc('${hit.path}')" class="space-y-2 cursor-pointer hover:bg-base-200">
            <h2 class="font-bold text-2xl">${components.Highlight({ attribute: 'title', hit })}</h2>
            <p>${hit.description}</p>
            <p class="italic">${components.Highlight({ attribute: 'path', hit })}</p>
          </a>
        `;
      },
    }
  })
]);

search.start();
