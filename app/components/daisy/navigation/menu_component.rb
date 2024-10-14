class Daisy::Navigation::MenuComponent < LocoMotion.configuration.base_component_class

  #
  # The items for the MenuComponent.
  #
  #
  class Daisy::Navigation::MenuItemComponent < LocoMotion.configuration.base_component_class
    define_part :title

    #
    # Create a new instance of the MenuItemComponent.
    #
    # @param title [String] (Optional) Shows an additional title above the item.
    # @param disabled [Boolean] (Optional) Sets the item in a disabled state.
    #
    def initialize(*args, **kws, &block)
      super

      @simple_title = config_option(:title)
      @disabled = config_option(:disabled)
    end

    def before_render
      set_tag_name(:component, :li)
      add_css(:component, "disabled pointer-events-none") if @disabled

      set_tag_name(:title, :h2)
      add_css(:title, "menu-title")
    end

    def call
      part(:component) do
        concat(part(:title) { @simple_title }) if @simple_title
        concat(content)
      end
    end
  end

  renders_many :items, Daisy::Navigation::MenuItemComponent

  def initialize(*args, **kws, &block)
    super
  end

  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "menu")
  end
end
