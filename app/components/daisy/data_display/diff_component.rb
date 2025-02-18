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
class Daisy::DataDisplay::DiffComponent < LocoMotion::BaseComponent
  #
  # A component for rendering individual items within the diff comparison.
  #
  class ItemComponent < LocoMotion::BasicComponent
    def set_index(index)
      @index = index
    end

    def before_render
      # Because we're using the same component for many items, we need to
      # manually specify the item class names to make sure Tailwind picks them
      # up and includes them in the final CSS.
      #
      # diff-item-1 diff-item-2
      add_css(:component, "diff-item-#{@index}")
    end
  end

  define_part :resizer

  renders_many :items, ItemComponent

  def before_render
    add_css(:component, "diff")
    add_css(:resizer, "diff-resizer")
  end
end
