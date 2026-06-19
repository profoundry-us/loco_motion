# frozen_string_literal: true

module Daisy
  module DataInput
    # Renders a fieldset element, optionally with a legend, to group
    # related form controls or content.
    #
    # @note Use the `caption` slot (or the `caption:` argument) for caption /
    #   helper text below the controls — it renders DaisyUI's
    #   `.fieldset-label`, which (unlike `.label` / `daisy_label`) is **not**
    #   `white-space: nowrap`, so long help text wraps instead of pushing the
    #   form off-screen. `.fieldset-label` is `display: flex`, which splits a
    #   sentence and an inline link into separate flex items; for prose that
    #   contains a link, pass `caption_css: "block"` so the link flows inside
    #   the sentence.
    #
    # @part legend The `<legend>` element rendered for the `legend:` argument.
    # @part caption The `<div class="fieldset-label">` caption rendered for the
    #   `caption:` argument.
    #
    # @slot legend Custom content for the legend (title).
    # @slot caption Custom content for the caption / helper text shown below the
    #   fieldset's controls.
    #
    # @loco_example Basic fieldset
    #   = daisy_fieldset do
    #     Content inside fieldset
    #
    # @loco_example Fieldset with legend slot
    #   = daisy_fieldset do |fieldset|
    #     - fieldset.with_legend { "My Legend" }
    #
    #     Content inside fieldset
    #
    # @loco_example Fieldset with legend argument
    #   = daisy_fieldset(legend: "My Legend") do
    #     Content inside fieldset
    #
    # @loco_example Fieldset with caption / helper text
    #   = daisy_fieldset(legend: "Theme", caption: "Used for newly created charts.") do
    #     = daisy_select(options: ["Light", "Dark"])
    #
    # @loco_example Caption with an inline link (override the flex display)
    #   = daisy_fieldset(legend: "Theme") do |fieldset|
    #     = daisy_select(options: ["Light", "Dark"])
    #     - fieldset.with_caption(css: "block") do
    #       Manage themes on the
    #       = link_to "Themes", "/themes"
    #       page.
    #
    class FieldsetComponent < LocoMotion::BaseComponent
      self.component_name = :fieldset

      define_parts :legend, :caption

      # The legend (title) for the fieldset. Renders a `<legend>` tag.
      # Can be provided as a slot or via the `legend` argument.
      renders_one :legend, LocoMotion::BasicComponent.build(tag_name: :legend, css: "fieldset-legend")

      # The caption / helper text for the fieldset. Renders a
      # `<div class="fieldset-label">` after the content. Can be provided as a
      # slot or via the `caption` argument.
      renders_one :caption, LocoMotion::BasicComponent.build(tag_name: :div, css: "fieldset-label")

      # @param legend [String] Optional simple text for the legend.
      #   Ignored if the `legend` slot is used.
      #
      # @param caption [String] Optional simple caption / helper text rendered
      #   below the content using DaisyUI's `.fieldset-label`. Ignored if the
      #   `caption` slot is used.
      def initialize(legend: nil, caption: nil, **kws)
        @simple_legend = legend
        @simple_caption = caption

        super(**kws)
      end

      def before_render
        setup_component

        super
      end

      private

      # Sets up default tags and classes for the component and its parts.
      def setup_component
        set_tag_name(:component, :fieldset)
        set_tag_name(:legend, :legend)
        set_tag_name(:caption, :div)

        add_css(:legend, "fieldset-legend")
        add_css(:caption, "fieldset-label")
        add_css(:component, "fieldset")
      end
    end
  end
end
