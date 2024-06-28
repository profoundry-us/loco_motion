# This is the stats component.
class Daisy::DataDisplay::StatComponent < LocoMotion.configuration.base_component_class
  set_component_name :stat

  define_parts :title, :value, :description

  renders_one :title
  renders_one :description

  attr_reader :simple_title
  attr_reader :simple_description

  # Create a new stat component.
  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title)
    @simple_description = config_option(:description)
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
  end
end
