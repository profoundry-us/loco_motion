#
# The Dropdown component shows a Button, or any other component you wish, with a
# hovering menu that opens on click (or hover).
#
# @part menu The default / styled menu rendered by the dropdown.
# @part menu_item The syles for every item in the dropdown.
#
# @slot button The button that triggers the dropdown.
# @slot activator A custom (i.e. non-button) activator for the dropdown.
#   Automatically adds the `role="button"` and `tabindex="0"` attributes.
# @slot item+ The items in the dropdown.
#
# @loco_example Basic Usage
#  = daisy_dropdown do |dropdown|
#    - dropdown.with_item do
#      = link_to "Item 1", "#"
#    - dropdown.with_item do
#      = link_to "Item 2", "#"
#    - dropdown.with_item do
#      = link_to "Item 3", "#"
#
class Daisy::Actions::DropdownComponent < LocoMotion::BaseComponent

  include ViewComponent::SlotableDefault

  define_parts :menu, :menu_item

  renders_one :button, Daisy::Actions::ButtonComponent
  renders_one :activator, LocoMotion::BasicComponent.build(html: { role: "button", tabindex: 0 })
  renders_many :items

  #
  # Creates a new instance of the DropdownComponent.
  #
  # @param title If provided, the first argument is considered the title of the
  #   dropdown.
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws title [String] The title of the dropdown.
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

