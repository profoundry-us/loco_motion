# frozen_string_literal: true

module Daisy
  module Actions
    #
    # The ThemeController is the foundation for theme switching. For a complete,
    # ready-made switcher, use the {#build_switcher_dropdown} builder; to build a
    # custom switcher, compose the lower-level builders ({#build_theme_preview},
    # {#build_radio_input}) yourself. Either way it wires up the `loco-theme`
    # Stimulus controller for you.
    #
    # @loco_example A complete switcher in one line
    #   = daisy_theme_controller(themes: %w[light dark]) do |tc|
    #     = tc.build_switcher_dropdown
    #
    # @loco_example Composing the lower-level builders
    #   = daisy_theme_controller do |tc|
    #     - tc.themes.each do |theme|
    #       = tc.build_theme_preview(theme)
    #       = tc.build_radio_input(theme)
    #
    class ThemeControllerComponent < LocoMotion::BaseComponent
      # Default list of themes to display in the controller
      SOME_THEMES = %w[light dark synthwave retro cyberpunk wireframe].freeze

      # @return [Array<String>] The DaisyUI theme names available in this
      #   controller.
      attr_reader :themes

      #
      # Creates a new instance of the ThemeControllerComponent.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws themes [Array<String>] List of DaisyUI theme names to
      #   include in the controller. Defaults to {SOME_THEMES}.
      #
      def initialize(**kws, &block)
        super

        @themes = config_option(:themes, SOME_THEMES)
      end

      #
      # Sets up the component with theme Stimulus controller.
      #
      def before_render
        add_stimulus_controller(:component, "loco-theme")
      end

      #
      # Renders the component and its content.
      #
      def call
        part(:component) { content }
      end

      #
      # Builder method to create a radio input for use in selecting themes.
      #
      # @param theme [String] The name of the theme that the input controls.
      #
      # @param scheme [Symbol, String, nil] Scope the radio to one color
      #   scheme (`:light` / `:dark`) for day / night picker UIs. Scheme
      #   radios omit the `theme-controller` class (so a checked-but-inactive
      #   pick can't force its theme onto the page via DaisyUI's CSS) and
      #   sync their checked state to the scheme's saved preference instead
      #   of the active theme. Defaults to nil.
      #
      # @param options [Hash] Additional options to pass to the component.
      #
      # @yield [radio] An optional block forwarded to the radio so you can
      #   fill its `leading` / `trailing` slots (e.g. drop a preview swatch
      #   or label inside the radio's label and make the whole row one
      #   clickable control).
      #
      # @return [String] The rendered HTML for the radio input.
      #
      # @loco_example Put a preview + label inside the radio
      #   = daisy_theme_controller do |tc|
      #     - tc.themes.each do |theme|
      #       = tc.build_radio_input(theme) do |radio|
      #         - radio.with_trailing(css: "flex items-center gap-2") do
      #           = tc.build_theme_preview(theme)
      #           %span.capitalize= theme.humanize
      #
      def build_radio_input(theme, scheme: nil, **options, &block)
        # Scheme-scoped radios deliberately OMIT the `theme-controller`
        # class: DaisyUI's own CSS applies a theme whenever any checked
        # `.theme-controller` input carries its name, and a scheme picker's
        # radio stays checked even while the OTHER scheme is active — the
        # class would force its theme onto the page. The data attribute
        # tells the Stimulus controller to sync it to the scheme's saved
        # slot instead of the active theme.
        if scheme
          options[:html] = { data: { "loco-theme-scheme": scheme } }.deep_merge(options[:html] || {})
        else
          options[:css] = "#{options[:css]} theme-controller".lstrip
        end

        # Namespace the id by the input name so multiple theme controllers can
        # coexist on the same page without generating duplicate ids.
        name = options[:name] || "theme"
        default_options = { name: name, id: "#{name}-#{theme}", value: theme }

        render(Daisy::DataInput::RadioButtonComponent.new(**default_options.deep_merge(options)), &block)
      end

      #
      # Builder method to create a theme preview showing the theme's colors in a 2x2
      # grid.
      #
      # @param theme [String] The theme name to preview.
      #
      # @option options css [String] Additional CSS classes.
      #
      # @return [String] The rendered HTML for the theme preview.
      #
      def build_theme_preview(theme, **options)
        render Daisy::Actions::ThemePreviewComponent.new(
          theme: theme,
          **options
        )
      end

      #
      # Builder method that renders a complete, ready-to-use theme switcher
      # dropdown: a trigger button and a menu with one row per theme (a color
      # preview, the theme name, and a checkmark on the active theme), all wired
      # to the `loco-theme` controller. Because it is rendered inside this
      # component, it inherits the `loco-theme` Stimulus controller, so no extra
      # setup is required.
      #
      # @param icon [String] The icon name for the trigger button. Defaults
      #   to "swatch".
      #
      # @param label [String, nil] Optional text shown beside the trigger
      #   icon. When omitted, the trigger is an icon-only circle button.
      #
      # @param clear [Boolean] Whether to append a "Clear Theme" row that
      #   resets to the default theme. Defaults to false.
      #
      # @param scheme [Symbol, String, nil] Scope this dropdown to one color
      #   scheme (`:light` or `:dark`), turning it into a "Day theme" /
      #   "Night theme" picker. Picking applies immediately like any
      #   switcher (an explicit choice always shows, even a night theme
      #   during the day) and saves as that scheme's preferred theme — the
      #   difference is the checkmark, which tracks the scheme's saved
      #   preference rather than the page's active theme. Pass only themes
      #   belonging to that scheme. Pair two of these with
      #   {#build_night_toggle} and {#build_system_toggle} for a
      #   GitHub-style appearance picker. Defaults to nil (a classic
      #   switcher).
      #
      # @param name [String] The shared `name` for the theme radios.
      #   Defaults to "theme".
      #
      # @param css [String] Extra CSS classes for the dropdown (e.g. a
      #   placement modifier like "dropdown-end"). Defaults to
      #   "dropdown-end".
      #
      # @return [String] The rendered dropdown.
      #
      # @loco_example A one-line theme switcher
      #   = daisy_theme_controller(themes: %w[light dark synthwave]) do |tc|
      #     = tc.build_switcher_dropdown
      #
      # @loco_example With a label and a Clear Theme row
      #   = daisy_theme_controller do |tc|
      #     = tc.build_switcher_dropdown(label: "Theme", clear: true)
      #
      # @loco_example Day / night pickers with night-mode and OS-sync toggles
      #   .flex.gap-4.items-center
      #     = daisy_theme_controller(themes: %w[light retro]) do |tc|
      #       = tc.build_switcher_dropdown(label: "Day theme", scheme: :light, name: "day-theme")
      #     = daisy_theme_controller(themes: %w[dark synthwave]) do |tc|
      #       = tc.build_switcher_dropdown(label: "Night theme", scheme: :dark, name: "night-theme")
      #     = daisy_theme_controller do |tc|
      #       = tc.build_night_toggle
      #     = daisy_theme_controller do |tc|
      #       = tc.build_system_toggle
      #
      def build_switcher_dropdown(icon: "swatch", label: nil, clear: false, scheme: nil, name: "theme", css: "dropdown-end")
        button_css = label ? "btn-ghost" : "btn-ghost btn-circle"

        render(Daisy::Actions::DropdownComponent.new(css: css)) do |dropdown|
          dropdown.with_button(icon: icon, title: label, css: button_css,
                               html: { title: "Switch theme", "aria-label": "Switch theme" })

          dropdown.with_item { clear_row(name) } if clear

          themes.each do |theme|
            dropdown.with_item { switcher_row(theme, name, scheme: scheme) }
          end
        end
      end

      #
      # Builder method that renders a "Night mode" toggle wired to the
      # `loco-theme` controller. Checking it pins the dark scheme — the
      # saved night theme applies immediately, letting users try night mode
      # without touching their OS settings — and unchecking pins light.
      # Either direction is an explicit choice, so it leaves `system` mode.
      # The toggle's checked state tracks the scheme actually showing, so it
      # reads correctly in system mode too.
      #
      # @param title [String] The label text shown after the toggle.
      #   Defaults to "Night mode".
      #
      # @param name [String] The `name` (and default `id`) for the toggle's
      #   checkbox. Defaults to "theme-night".
      #
      # @param css [String] Extra CSS classes for the toggle input.
      #   Defaults to "".
      #
      # @return [String] The rendered toggle.
      #
      # @loco_example A night-mode toggle beside day / night pickers
      #   = daisy_theme_controller do |tc|
      #     = tc.build_night_toggle
      #
      def build_night_toggle(title: "Night mode", name: "theme-night", css: "")
        render(Daisy::DataInput::ToggleComponent.new(
                 name: name, id: name, css: css, trailing: title,
                 html: { data: { "loco-theme-night-toggle": true,
                                 action: "change->loco-theme#toggleNightMode" } }
               ))
      end

      #
      # Builder method that renders a "Match system appearance" toggle wired
      # to the `loco-theme` controller. Checking it enters `system` mode —
      # the active theme follows the OS color scheme live, swapping between
      # the saved light and dark preferences — and unchecking it pins the
      # currently-visible scheme, so the page doesn't change when sync turns
      # off. The controller keeps the toggle's checked state in sync with
      # the saved mode across every switcher on the page.
      #
      # @param title [String] The label text shown after the toggle.
      #   Defaults to "Match system appearance".
      #
      # @param name [String] The `name` (and default `id`) for the toggle's
      #   checkbox. Defaults to "theme-mode".
      #
      # @param css [String] Extra CSS classes for the toggle input.
      #   Defaults to "".
      #
      # @return [String] The rendered toggle.
      #
      # @loco_example An OS-sync toggle beside a switcher
      #   = daisy_theme_controller do |tc|
      #     = tc.build_switcher_dropdown
      #     = tc.build_system_toggle
      #
      def build_system_toggle(title: "Match system appearance", name: "theme-mode", css: "")
        render(Daisy::DataInput::ToggleComponent.new(
                 name: name, id: name, css: css, trailing: title,
                 html: { data: { "loco-theme-mode-toggle": true,
                                 action: "change->loco-theme#toggleSystemMode" } }
               ))
      end

      private

      # Renders a single theme row for {build_switcher_dropdown}: a clickable
      # link wrapping a hidden radio (the `peer` that drives the checkmark)
      # plus the preview, name, and checkmark. The explicit `setTheme` action
      # is what makes selection reliable inside a focus dropdown (a hidden
      # radio's `change` event does not propagate there). Scheme-scoped rows
      # apply exactly like classic rows — an explicit pick always shows
      # immediately — they only differ in checkmark bookkeeping (the radio
      # tracks the scheme's saved slot).
      def switcher_row(theme, name, scheme: nil)
        parts = [
          build_radio_input(theme, name: name, scheme: scheme, css: "hidden peer"),
          build_theme_preview(theme, css: "size-5"),
          content_tag(:span, theme.humanize, class: "grow capitalize"),
          helpers.loco_icon("check", css: "size-4 text-primary invisible peer-checked:visible")
        ]

        link_to("#", class: "flex items-center gap-3 no-underline",
                     data: { action: "click->loco-theme#setTheme" }) { safe_join(parts) }
      end

      # Renders the optional, danger-styled "Clear Theme" row, shown at the top
      # of the menu. Uses a `<button>` (not a link) because
      # `loco-theme#clearTheme` does not `preventDefault`, so an `href="#"`
      # would jump the page. The `themeName` param lets the controller uncheck
      # this switcher's radios immediately.
      def clear_row(name)
        parts = [
          helpers.loco_icon("trash", css: "size-4"),
          content_tag(:span, "Clear Theme", class: "grow text-left")
        ]

        content_tag(:button, type: "button",
                             class: "flex items-center gap-3 w-full text-error",
                             data: { action: "loco-theme#clearTheme",
                                     "loco-theme-theme-name-param": name }) do
          safe_join(parts)
        end
      end
    end
  end
end
