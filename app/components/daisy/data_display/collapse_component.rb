class Daisy::DataDisplay::CollapseComponent < LocoMotion.configuration.base_component_class
  prepend LocoMotion::Concerns::TippableComponent

  define_parts :title, :wrapper

  renders_one :title

  attr_reader :simple_title, :checkbox

  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title)
    @checkbox = config_option(:checkbox, true)
  end

  def before_render
    setup_component
    setup_title
    setup_wrapper
  end

  def setup_component
    add_css(:component, "collapse")
    add_html(:component, { tabindex: 0 }) unless @checkbox
  end

  def setup_title
    add_css(:title, "collapse-title")
  end

  def setup_wrapper
    add_css(:wrapper, "collapse-content")
  end

  def has_title?
    title? || @simple_title.present?
  end
end
