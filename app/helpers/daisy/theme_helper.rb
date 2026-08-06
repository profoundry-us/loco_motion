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
    # renders. It resolves the saved theme mode (`light` / `dark` pin that
    # scheme; `system` follows the OS preference) and the matching per-scheme
    # theme preference, then sets the `data-theme` and `data-color-scheme`
    # attributes on the html element. The legacy single `savedTheme` key is
    # still honored until the ThemeController migrates it.
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
              var mode = localStorage.getItem('savedThemeMode');
              var theme = null;
              var scheme = null;

              if (mode) {
                scheme = mode === 'system'
                  ? (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
                  : mode;
                theme = localStorage.getItem(scheme === 'dark' ? 'savedDarkTheme' : 'savedLightTheme') || scheme;
              } else {
                // Legacy single-theme key; the ThemeController migrates it to
                // the per-scheme model on connect.
                theme = localStorage.getItem('savedTheme');
              }

              if (theme) {
                document.documentElement.setAttribute('data-theme', theme);
              }
              if (scheme) {
                document.documentElement.setAttribute('data-color-scheme', scheme);
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
