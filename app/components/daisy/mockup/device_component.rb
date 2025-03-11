#
# The DeviceComponent creates realistic device mockups for showcasing mobile
# and tablet applications. Common use cases include:
# - Displaying mobile app screenshots.
# - Creating marketing materials.
# - Demonstrating responsive designs.
# - Building portfolio pieces.
#
# The component includes an optional camera element and a display area that
# can contain any content with appropriate sizing classes.
#
# @part camera The device's camera element, shown at the top by default.
# @part display The main display area of the device.
#
# @loco_example Phone with Camera
#   = daisy_device(css: "mockup-phone", display_css: "overflow-auto") do
#     .flex.flex-col.gap-4.p-4.pt-12.pb-8.bg-white
#       .text-2xl.font-bold
#         My App
#       = image_tag("screenshot.jpg",
#         class: "rounded-lg")
#
# @loco_example Tablet without Camera
#   = daisy_device(css: "mockup-phone border-primary",
#     display_css: "overflow-auto w-[736px] h-[414px]", show_camera: false) do
#     .flex.flex-col.gap-4.p-4.bg-white
#       Tablet Content Here
#
# @loco_example Styled Device
#   = daisy_device(css: "mockup-phone border-4
#     border-accent shadow-xl", display_css: "w-[320px] h-[568px]") do
#     .flex.flex-col.p-4.bg-gradient-to-br.from-primary.to-accent
#       Premium App Design
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
    add_css(:camera, "mockup-phone-camera")
    add_css(:display, "mockup-phone-display")
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
