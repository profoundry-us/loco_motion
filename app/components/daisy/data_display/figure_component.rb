#
# The FigureComponent is used to display images with optional captions. It is
# commonly used within cards and other content containers.
#
# @part image The image element when a source URL is provided.
#
# @loco_example Basic Usage
#   = daisy_figure(src: "example.jpg")
#
# @loco_example With Caption
#   = daisy_figure(src: "example.jpg") do
#     A beautiful landscape
#
# @loco_example Without Image
#   = daisy_figure do
#     Content when no image is provided
#
# @loco_example Image Position Bottom
#   = daisy_figure(src: "example.jpg", position: "bottom") do
#     Caption appears above the image
#
class Daisy::DataDisplay::FigureComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::LinkableComponent

  define_part :image, tag_name: :img

  # Creates a new figure component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws src [String] URL of the image to display in the figure.
  #
  # @option kws position [Symbol] Position of the image relative to content.
  #   Must be :top (default) or :bottom.
  #
  # @option kws css [String] Additional CSS classes for styling.
  #
  def initialize(**kws, &block)
    super

    @src = kws[:src]
    @position = kws[:position] || :top

    validate_position!
  end

  def before_render
    set_tag_name(:component, :figure)
    add_html(:image, src: @src) if @src

    super
  end

  def call
    part(:component) do
      if @position == :bottom
        # Show content first, then image
        concat(content)
        concat(part(:image)) if @src
      else
        # Default: show image first, then content
        concat(part(:image)) if @src
        concat(content)
      end
    end
  end

  private

  def validate_position!
    unless %i[top bottom].include?(@position)
      raise ArgumentError, "position must be :top or :bottom, got '#{@position}'"
    end
  end
end
