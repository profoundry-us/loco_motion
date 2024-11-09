# This is the stats component.
class Daisy::DataDisplay::StatComponent < LocoMotion.configuration.base_component_class
  prepend LocoMotion::Concerns::TippableComponent

  set_component_name :stat

  define_parts :title, :value, :description, :figure

  renders_one :title
  renders_one :description
  renders_one :figure

  attr_reader :simple_title
  attr_reader :simple_description

  # Create a new stat component.
  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title)
    @simple_description = config_option(:description)
    @src = config_option(:src)
    @icon = config_option(:icon)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:component, "stat")
    add_css(:title, "stat-title")
    add_css(:value, "stat-value")
    add_css(:description, "stat-desc")
    add_css(:figure, "stat-figure")

    if @src.nil?

    end
  end
end
