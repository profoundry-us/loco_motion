#
# A component that renders a menu with items.
#
# @slot item [Daisy::Navigation::MenuItemComponent] Renders one or more menu
#   items.
#
# @loco_example Basic Usage
#   = daisy_menu do |menu|
#     - # Menu Item with a grouping title via keyword argument
#     - menu.with_item(title: "Group 1") do
#       = link_to "Item 1 - 1", "#"
#
#     - # Menu Item with a grouping title as the first positional argument
#     - menu.with_item("Group 2") do
#       = link_to "Item 2 - 1", "#"
#
#     - # Menu Item with no grouping title
#     - menu.with_item do
#       = link_to "Item 2 - 2", "#"
#
class Daisy::Navigation::MenuComponent < LocoMotion::BaseComponent

  #
  # The items for the MenuComponent.
  #
  # @part title Wrapper for the title of the menu item.
  #
  class Daisy::Navigation::MenuItemComponent < LocoMotion::BaseComponent
    define_part :title

    #
    # Create a new instance of the MenuItemComponent.
    #
    # @param args [Array] If provided, the first argument is considered the
    #   `title`.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws title [String] Shows an additional title above the item.
    # @option kws disabled [Boolean] Sets the item in a disabled state.
    #
    def initialize(*args, **kws, &block)
      super

      @simple_title = config_option(:title, args[0])
      @disabled = config_option(:disabled)
    end

    #
    # Adds the relevant Daisy classes and applies the disabled state if
    # provided (utilizes Tailwind pointer-events-none).
    #
    def before_render
      set_tag_name(:component, :li)
      add_css(:component, "disabled pointer-events-none") if @disabled

      set_tag_name(:title, :h2)
      add_css(:title, "menu-title")
    end

    #
    # Renders the menu item component including a title if present.
    #
    def call
      part(:component) do
        concat(part(:title) { @simple_title }) if @simple_title
        concat(content)
      end
    end
  end

  renders_many :items, Daisy::Navigation::MenuItemComponent

  #
  # Create a new instance of the MenuComponent. Passes any arguments to the
  # BaseComponent.
  #
  def initialize(*args, **kws, &block)
    super
  end

  #
  # Sets the tag name to `<ul>` and adds the relevant Daisy classes.
  #
  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "menu")
  end
end
