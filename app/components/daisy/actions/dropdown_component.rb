# Here are the Button docs!
class Daisy::Actions::DropdownComponent < LocoMotion.configuration.base_component_class

  TitleComponent = LocoMotion::BasicComponent.build do
    def before_render
      add_html(:component, { role: "button", tabindex: 0 })
    end
  end

  ItemComponent = LocoMotion::BasicComponent.build do
    def before_render
      set_tag_name(:component, :li)
    end
  end

  define_parts :title, :menu

  renders_one :title, TitleComponent
  renders_many :items, ItemComponent

  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title, "Submit")
  end

  def before_render
    setup_component
    setup_title
    setup_menu
  end

  def setup_component
    add_css(:component, "dropdown")
  end

  def setup_title
    set_tag_name(:title, :div)
    add_css(:title, "btn")
    add_html(:title, { role: "button", tabindex: 0 })
  end

  def setup_menu
    set_tag_name(:menu, :ul)
    add_css(:menu, "dropdown-content menu bg-base-100 rounded-box shadow w-52 p-2 z-[1]")
    add_html(:menu, { role: "menu", tabindex: 0 })
  end
end
