#
# The DeviceComponent creates realistic device mockups for showcasing mobile
# and tablet applications. Common use cases include:
# - Displaying mobile app screenshots.
# - Creating marketing materials.
# - Demonstrating responsive designs.
# - Building portfolio pieces.
#
# The component includes an optional camera element and a display area that
# can contain any content, typically an ArtboardComponent for proper sizing.
#
# @part camera The device's camera element, shown at the top by default.
# @part display The main display area of the device.
#
# @loco_example Phone with Camera
#   = daisy_device(css: "mockup-phone") do
#     = daisy_artboard(css: "phone-2") do
#       .flex.flex-col.p-4
#         .text-2xl.font-bold
#           My App
#         = image_tag("screenshot.jpg",
#           class: "rounded-lg")
#
# @loco_example Tablet without Camera
#   = daisy_device(css: "mockup-phone border-primary",
#     show_camera: false) do
#     = daisy_artboard(css: "artboard-horizontal phone-3") do
#       .bg-base-100.p-4
#         Tablet Content Here
#
# @loco_example Styled Device
#   = daisy_device(css: "mockup-phone border-4
#     border-accent shadow-xl") do
#     = daisy_artboard(css: "phone-1") do
#       .bg-gradient-to-br.from-primary.to-accent.p-4
#         Premium App Design
#
class Daisy::Mockup::DeviceComponent < LocoMotion::BaseComponent

  define_parts :camera, :display

  #
  # Creates a new Device component.
  #
  # @option kws show_camera [Boolean] Whether to show the camera element
  #   (default: true).
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Type: `mockup-phone`
  #   - Border: `border-2`, `border-primary`
  #   - Shadow: `shadow-lg`, `shadow-xl`
  #
  def initialize(**kws)
    super(**kws)

    @show_camera = config_option(:show_camera, true)
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:camera, "camera")
    add_css(:display, "display")
    add_css(:display, "!mt-0") if !@show_camera
  end

  #
  # Renders the device with its camera (if enabled) and display content.
  #
  def call
    part(:component) do
      concat(part(:camera)) if @show_camera

      concat(part(:display) do
        content
      end)
    end
  end

end
