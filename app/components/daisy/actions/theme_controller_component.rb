# frozen_string_literal: true

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
module Daisy
  module Actions
    class ThemeControllerComponent < LocoMotion::BaseComponent
      # Default list of themes to display in the controller
      SOME_THEMES = %w[light dark synthwave retro cyberpunk wireframe].freeze

      attr_reader :themes

      #
      # Creates a new instance of the ThemeControllerComponent.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws [Array<String>] :themes List of DaisyUI theme names to include
      #   in the controller. Defaults to {SOME_THEMES}.
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
      # @param options [Hash] Additional options to pass to the component.
      #
      # @yield [radio] An optional block forwarded to the radio so you can fill
      #   its `start` / `end` slots (e.g. drop a preview swatch or label inside
      #   the radio's label and make the whole row one clickable control).
      #
      # @return [Daisy::DataInput::RadioButtonComponent] A new radio button
      #   component instance.
      #
      # @loco_example Put a preview + label inside the radio
      #   = daisy_theme_controller do |tc|
      #     - tc.themes.each do |theme|
      #       = tc.build_radio_input(theme) do |radio|
      #         - radio.with_end do
      #           = tc.build_theme_preview(theme)
      #           %span.capitalize= theme.humanize
      #
      def build_radio_input(theme, **options, &block)
        options[:css] = "#{options[:css]} theme-controller".lstrip

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
      # @option options [Integer] :size Size of the preview in Tailwind size units.
      #   Defaults to 4 (1rem).
      #
      # @option options [Boolean] :shadow Whether to add a shadow. Defaults to true.
      #
      # @option options [String] :css Additional CSS classes.
      #
      # @return [Daisy::Actions::ThemePreviewComponent] A new theme preview
      #   component instance.
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
      # @option options [String] :icon The Heroicon name for the trigger button.
      #   Defaults to "swatch".
      #
      # @option options [String] :label Optional text shown beside the trigger
      #   icon. When omitted, the trigger is an icon-only circle button.
      #
      # @option options [Boolean] :clear Whether to append a "Clear Theme" row
      #   that resets to the default theme. Defaults to false.
      #
      # @option options [String] :name The shared `name` for the theme radios.
      #   Defaults to "theme".
      #
      # @option options [String] :css Extra CSS classes for the dropdown (e.g. a
      #   placement modifier like "dropdown-end"). Defaults to "dropdown-end".
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
      def build_switcher_dropdown(icon: "swatch", label: nil, clear: false, name: "theme", css: "dropdown-end")
        button_css = label ? "btn-ghost" : "btn-ghost btn-circle"

        render(Daisy::Actions::DropdownComponent.new(css: css)) do |dropdown|
          dropdown.with_button(icon: icon, title: label, css: button_css,
                               html: { title: "Switch theme", "aria-label": "Switch theme" })

          dropdown.with_item { clear_row(name) } if clear

          themes.each do |theme|
            dropdown.with_item { switcher_row(theme, name) }
          end
        end
      end

      private

      # Renders a single theme row for {build_switcher_dropdown}: a clickable
      # link wrapping a hidden `.theme-controller` radio (the `peer` that drives
      # the checkmark) plus the preview, name, and checkmark. The explicit
      # `setTheme` action is what makes selection reliable inside a focus
      # dropdown (a hidden radio's `change` event does not propagate there).
      def switcher_row(theme, name)
        parts = [
          build_radio_input(theme, name: name, css: "hidden peer"),
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
