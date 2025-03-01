#
# The BrowserComponent creates a realistic browser window mockup, perfect for:
# - Showcasing web applications.
# - Creating website previews.
# - Demonstrating responsive designs.
# - Building marketing materials.
#
# The component includes an optional toolbar for URL input and browser
# controls, and a content area that can contain any content you wish to
# display.
#
# @slot toolbar [LocoMotion::BasicComponent] An optional toolbar section,
#   typically containing a URL input field or navigation controls.
#
# @loco_example Basic Browser with URL
#   = daisy_browser(css: "w-full border border-base-300") do |browser|
#     - browser.with_toolbar do
#       %input.input.input-bordered{
#         placeholder: "https://example.com" }
#
#     .border-t.border-base-300.p-4
#       Your website content here
#
# @loco_example Styled Browser
#   = daisy_browser(css: "bg-primary border-2") do |browser|
#     - browser.with_toolbar do
#       .flex.gap-2.px-4
#         = daisy_button(icon: "chevron-left",
#           css: "btn-circle btn-sm")
#         = daisy_button(icon: "chevron-right",
#           css: "btn-circle btn-sm")
#         %input.input.input-sm.flex-1{
#           placeholder: "Search..." }
#
#     .bg-base-100.p-8.text-center
#       Professional website mockup
#
# @loco_example Content-Only Browser
#   = daisy_browser(css: "border shadow-lg") do
#     .p-4
#       Simple browser frame without toolbar
#
class Daisy::Mockup::BrowserComponent < LocoMotion::BaseComponent

  renders_one :toolbar, LocoMotion::BasicComponent.build(css: "mockup-browser-toolbar")

  #
  # Creates a new Browser component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Size: `w-full`, `max-w-4xl`
  #   - Border: `border`, `border-2`, `border-primary`
  #   - Background: `bg-base-100`, `bg-primary`
  #   - Shadow: `shadow`, `shadow-lg`
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Sets up the component's CSS classes.
  #
  def before_render
    add_css(:component, "mockup-browser")
  end

  #
  # Renders the toolbar (if present) and content.
  #
  def call
    part(:component) do
      concat(toolbar) if toolbar
      concat(content)
    end
  end

end
