# frozen_string_literal: true

#
# ThemeHelper provides helper methods for theme-related functionality.
#
module Daisy
  module ThemeHelper
    #
    # Returns an inline script that preloads the saved theme from localStorage
    # to prevent a flash of content when the page loads.
    #
    # This script runs synchronously in the head section before the page
    # renders, setting the `data-theme` attribute on the html element if a
    # theme has been saved in localStorage.
    #
    # @return [String] The inline script as a string
    #
    # @example In a layout file
    #   %head
    #     = theme_preload_script
    #     = stylesheet_link_tag "application"
    #
    def theme_preload_script
      <<~SCRIPT.html_safe
        <script>
          (function() {
            try {
              var savedTheme = localStorage.getItem('savedTheme');
              if (savedTheme) {
                document.documentElement.setAttribute('data-theme', savedTheme);
              }
            } catch (e) {
              // localStorage not available (e.g., private browsing mode)
            }
          })();
        </script>
      SCRIPT
    end
  end
end

# Include the ThemeHelper in ActionView::Base
ActionView::Base.include(Daisy::ThemeHelper)
