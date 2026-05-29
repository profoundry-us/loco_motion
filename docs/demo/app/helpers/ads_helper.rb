#
# AdsHelper provides helper methods for ads-related functionality.
#
module AdsHelper
  #
  # Returns an inline script that preloads the ads visibility state to prevent
  # a flash of content when the page loads.
  #
  # This script runs synchronously in the head section before the page
  # renders, setting the appropriate CSS classes for ads visibility based on
  # whether the current page has a hidden target.
  #
  # @return [String] The inline script as a string
  #
  # @example In a layout file
  #   %head
  #     = ads_preload_script
  #     = stylesheet_link_tag "application"
  #
  def ads_preload_script
    <<~SCRIPT.html_safe
      <script>
        (function() {
          try {
            var hiddenTarget = document.querySelector('[data-ads-target="hidden"]');
            var adsTarget = document.querySelector('[data-ads-target="ads"]');
            var contentTarget = document.querySelector('[data-ads-target="content"]');

            if (adsTarget && contentTarget) {
              if (hiddenTarget) {
                // Hide ads by removing the lg:block! class
                adsTarget.classList.remove('lg:block!');
                contentTarget.classList.remove('lg:pr-64');
              } else {
                // Show ads by adding the lg:block! class
                adsTarget.classList.add('lg:block!');
                contentTarget.classList.add('lg:pr-64');
              }
            }
          } catch (e) {
            // Elements not available yet or localStorage not available
          }
        })();
      </script>
    SCRIPT
  end
end
