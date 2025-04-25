# frozen_string_literal: true

module Daisy
  module DataInput
    # Renders a fieldset element, optionally with a legend, to group
    # related form controls or content.
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
    class FieldsetComponent < LocoMotion::BaseComponent
      self.component_name = :fieldset

      define_parts :legend

      # The legend (title) for the fieldset. Renders a `<legend>` tag.
      # Can be provided as a slot or via the `legend` argument.
      renders_one :legend, LocoMotion::BasicComponent.build(tag_name: :legend, css: "fieldset-legend")

      # @param legend [String] Optional simple text for the legend.
      #   Ignored if the `legend` slot is used.
      def initialize(legend: nil, **kws)
        @simple_legend = legend

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

        add_css(:legend, "fieldset-legend")
        add_css(:component, "fieldset")
      end
    end
  end
end
