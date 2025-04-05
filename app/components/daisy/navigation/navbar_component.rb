#
# Creates a navigation bar component typically used at the top of a page to
# organize navigation links and branding elements.
#
# @slot start {LocoMotion::BasicComponent} The left section of the navbar.
#   Automatically gets the `navbar-start` CSS class.
#
# @slot center {LocoMotion::BasicComponent} The center section of the navbar.
#   Automatically gets the `navbar-center` CSS class.
#
# @slot end {LocoMotion::BasicComponent} The right section of the navbar.
#   Automatically gets the `navbar-end` CSS class.
#
# @example Basic navbar with logo and GitHub link
#   = daisy_navbar(css: "bg-base-100") do |navbar|
#     - navbar.with_start do
#       = image_tag("logo.png", class: "h-8")
#       %span.font-bold Company Name
#
#     - navbar.with_end do
#       = link_to "GitHub", "https://github.com", target: "_blank"
#
# @example Navbar with all sections and dropdown
#   = daisy_navbar(css: "bg-base-100") do |navbar|
#     - navbar.with_start do
#       %span.text-lg.italic Brand
#
#     - navbar.with_center do
#       = hero_icon("code-bracket", css: "size-14")
#
#     - navbar.with_end do
#       = daisy_dropdown do |dropdown|
#         - dropdown.with_button(title: "Menu")
#         - dropdown.with_item do
#           = link_to "Item 1", "#"
#
class Daisy::Navigation::NavbarComponent < LocoMotion::BaseComponent
  renders_one :start, LocoMotion::BasicComponent.build(css: "navbar-start")

  renders_one :center, LocoMotion::BasicComponent.build(css: "navbar-center")

  renders_one :end, LocoMotion::BasicComponent.build(css: "navbar-end")

  # Create a new instance of the NavbarComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Background: `bg-base-100`, `bg-neutral`
  #   - Border: `border`, `border-base-200`, `rounded-lg`
  #   - Shadow: `shadow`, `shadow-lg`
  #   - Min Height: `min-h-8`, `min-h-16`
  #
  def initialize(**kws)
    super(**kws)
  end

  def before_render
    add_css(:component, "navbar")
  end
end
