# frozen_string_literal: true

#
# Creates a menu component for displaying a list of items, optionally with group titles.
#
# @note Vertical menus no longer have a default width. Use `w-full` or other width
#   classes if you want to control the width.
#
# @slot items+ {Daisy::Navigation::MenuItemComponent} The menu items to display.
#
# @example Basic menu with items
#   = daisy_menu do |menu|
#     - menu.with_item do
#       = link_to "Item 1", "#"
#     - menu.with_item do
#       = link_to "Item 2", "#"
#
# @example Menu with group titles
#   = daisy_menu do |menu|
#     - menu.with_item(title: "Group 1") do
#       = link_to "Item 1-1", "#"
#       = link_to "Item 1-2", "#"
#     - menu.with_item("Group 2") do
#       = link_to "Item 2-1", "#"
#       = link_to "Item 2-2", "#"
#
# @example Menu with disabled items
#   = daisy_menu do |menu|
#     - menu.with_item do
#       = link_to "Active Item", "#", class: "menu-active"
#     - menu.with_item(disabled: true) do
#       Disabled Item
#
class Daisy::Navigation::MenuComponent < LocoMotion::BaseComponent

  #
  # A menu item component that can optionally have a title and be disabled.
  #
  # @part title The title element for the menu item.
  #
  # @example Basic menu item
  #   = menu.with_item do
  #     = link_to "Item", "#"
  #
  # @example Menu item with title
  #   = menu.with_item(title: "Group") do
  #     = link_to "Item", "#"
  #
  # @example Disabled menu item
  #   = menu.with_item(disabled: true) do
  #     = link_to "Item", "#"
  #
  class Daisy::Navigation::MenuItemComponent < LocoMotion::BaseComponent
    define_part :title

    # Create a new instance of the MenuItemComponent.
    #
    # @param args [Array] If provided, the first argument is considered the
    #   `title`.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws title [String] Shows an additional title above the item.
    #
    # @option kws disabled [Boolean] Sets the item in a disabled state.
    #
    # @option kws css [String] Additional CSS classes for styling. Common
    #   options include:
    #   - Text: `text-sm`, `text-base-content`
    #   - Spacing: `mt-4`, `mb-2`
    #   - State: `menu-active`, `menu-focus`, `menu-disabled`
    #
    def initialize(*args, **kws)
      super(**kws)

      @simple_title = config_option(:title, args[0])
      @disabled = config_option(:disabled)
    end

    #
    # Adds the relevant Daisy classes and applies the disabled state if
    # provided (utilizes Tailwind pointer-events-none).
    #
    def before_render
      set_tag_name(:component, :li)
      add_css(:component, "menu-disabled pointer-events-none") if @disabled

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

  # Create a new instance of the MenuComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Layout: `menu-horizontal`, `w-full`, `w-56`
  #   - Background: `bg-base-100`, `bg-neutral`
  #   - Border: `border`, `rounded-box`
  #   - Shadow: `shadow`, `shadow-lg`
  #
  def initialize(**kws)
    super(**kws)
  end

  #
  # Sets the tag name to `<ul>` and adds the relevant Daisy classes.
  #
  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "menu")
  end
end
