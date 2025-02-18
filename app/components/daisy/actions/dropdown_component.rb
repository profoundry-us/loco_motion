#
# The Dropdown component shows a Button, or any other component you wish, with a
# hovering menu that opens on click (or hover). It provides a flexible way to
# create dropdown menus with customizable triggers and content.
#
# Note that the dropdown uses slots for both the activator and menu items,
# allowing for maximum flexibility in how the dropdown is triggered and what
# content it displays.
#
# @part menu The default / styled menu rendered by the dropdown. Contains all
#   menu items and provides the dropdown's positioning and animation.
# @part menu_item The styles for every item in the dropdown. Provides consistent
#   spacing and hover states.
#
# @slot button The button that triggers the dropdown. This is the default trigger
#   and is styled automatically.
# @slot activator A custom (i.e. non-button) activator for the dropdown.
#   Automatically adds the `role="button"` and `tabindex="0"` attributes.
# @slot item+ The items in the dropdown. Each item will be styled consistently
#   with proper spacing and hover states.
#
# @loco_example Basic Usage
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_button do
#       Click me!
#     - dropdown.with_item do
#       Item 1
#     - dropdown.with_item do
#       Item 2
#
# @loco_example Custom Activator
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_activator do
#       = heroicon_tag "bars-3", css: "size-6"
#     - dropdown.with_item do
#       Menu Item 1
#     - dropdown.with_item do
#       Menu Item 2
#
# @loco_example Complex Items
#   = daisy_dropdown do |dropdown|
#     - dropdown.with_button do
#       User Settings
#     - dropdown.with_item do
#       .flex.gap-2.items-center
#         = heroicon_tag "user-circle"
#         Profile
#     - dropdown.with_item do
#       .flex.gap-2.items-center
#         = heroicon_tag "cog-6-tooth"
#         Settings
#     - dropdown.with_item do
#       .flex.gap-2.items-center.text-error
#         = heroicon_tag "arrow-right-on-rectangle"
#         Logout
#
class Daisy::Actions::DropdownComponent < LocoMotion::BaseComponent

  include ViewComponent::SlotableDefault

  define_parts :menu, :menu_item

  renders_one :activator, LocoMotion::BasicComponent.build(html: { role: "button", tabindex: 0 })
  renders_one :button, Daisy::Actions::ButtonComponent
  renders_many :items

  #
  # Creates a new instance of the DropdownComponent.
  #
  # @param title [String] The title of the dropdown. Will be used as the button
  #   text if no custom button or activator is provided.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] The title of the dropdown. You can also pass this
  #   as the first argument.
  #
  def initialize(title = nil, **kws, &block)
    super

    @simple_title = config_option(:title, title)
  end

  #
  # Adds the relevant Daisy classes to the component.
  #
  def before_render
    setup_component
    setup_menu
  end

  #
  # Add the `dropdown` CSS class to the component.
  #
  def setup_component
    add_css(:component, "dropdown")
  end

  #
  # Make the menu a `<ul> / <li>` element and add the relevant Daisy classes.
  #
  def setup_menu
    # Setup menu itself
    set_tag_name(:menu, :ul)
    add_css(:menu, "dropdown-content menu bg-base-100 rounded-box shadow w-52 p-2 z-[1]")

    # Setup menu items
    set_tag_name(:menu_item, :li)
  end

  #
  # Provides a default button if no button or custom activator is provided.
  #
  def default_button
    Daisy::Actions::ButtonComponent.new(title: @simple_title)
  end
end
