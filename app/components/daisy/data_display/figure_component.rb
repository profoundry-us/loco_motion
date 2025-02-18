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
class Daisy::DataDisplay::FigureComponent < LocoMotion::BaseComponent
  define_part :image, tag_name: :img

  # Creates a new figure component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws src [String] URL of the image to display in the figure.
  #
  # @option kws css [String] Additional CSS classes for styling.
  #
  def initialize(**kws, &block)
    super

    @src = kws[:src]
  end

  def before_render
    set_tag_name(:component, :figure)
    add_html(:image, src: @src) if @src
  end

  def call
    part(:component) do
      if @src
        part(:image)
      else
        content
      end
    end
  end
end
