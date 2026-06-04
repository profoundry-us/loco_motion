# frozen_string_literal: true

#
# The Diff component displays two items side by side with a resizable divider
# between them. It's perfect for comparing content or showing before/after
# states. The component requires exactly two items to function properly.
#
# @part resizer The draggable divider between items that allows resizing.
#
# @slot item Two items to be compared. Exactly two items must be provided.
#
# @loco_example Basic Usage
#   = daisy_diff do |diff|
#     - diff.with_item do
#       %img{ src: "before.jpg", alt: "Before" }
#     - diff.with_item do
#       %img{ src: "after.jpg", alt: "After" }
#
# @loco_example With Text Content
#   = daisy_diff do |diff|
#     - diff.with_item do
#       .p-4.prose
#         %h3 Original Text
#         %p Here is the first version of the text...
#     - diff.with_item do
#       .p-4.prose
#         %h3 Revised Text
#         %p Here is the improved version...
#
# @loco_example With Custom Resizer
#   = daisy_diff(resizer_css: "bg-primary hover:bg-primary-focus") do |diff|
#     - diff.with_item do
#       %img{ src: "before.jpg", alt: "Before" }
#     - diff.with_item do
#       %img{ src: "after.jpg", alt: "After" }
#
module Daisy
  module DataDisplay
    class DiffComponent < LocoMotion::BaseComponent
      #
      # A component for rendering individual items within the diff comparison.
      #
      class ItemComponent < LocoMotion::BasicComponent
        # Full class name strings are required here so Tailwind's scanner can detect
        # them. String interpolation or comments are skipped by the Ruby extractor
        # in Tailwind v4+.
        ITEM_CLASSES = %w[diff-item-1 diff-item-2].freeze

        # rubocop:disable Naming/AccessorMethodName
        def set_index(index)
          @index = index
        end
        # rubocop:enable Naming/AccessorMethodName

        def before_render
          add_css(:component, ITEM_CLASSES[@index - 1])
        end
      end

      define_part :resizer

      renders_many :items, ItemComponent

      def before_render
        add_css(:component, "diff")
        add_css(:resizer, "diff-resizer")
      end
    end
  end
end
