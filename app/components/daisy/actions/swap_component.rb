class Daisy::Actions::SwapComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  class SwapOn < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-on")
    end
  end

  class SwapOff < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-off")
    end
  end

  class SwapIndeterminate < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "swap-indeterminate")
    end
  end

  define_parts :checkbox, :on, :off

  renders_one :on, SwapOn
  renders_one :off, SwapOff
  renders_one :indeterminate, SwapIndeterminate

  attr_reader :simple_on, :simple_off

  def initialize(*args, **kwargs, &block)
    super

    @checked = config_option(:checked, false)
    @simple_on = config_option(:on)
    @simple_off = config_option(:off)
  end

  def before_render
    setup_component
    setup_checkbox
    setup_on_off
  end

  def setup_component
    set_tag_name(:component, :label)
    add_css(:component, "swap")
  end

  def setup_checkbox
    set_tag_name(:checkbox, :input)
    add_html(:checkbox, { type: "checkbox", checked: @checked })
  end

  def setup_on_off
    add_css(:on, "swap-on")
    add_css(:off, "swap-off")
  end
end
