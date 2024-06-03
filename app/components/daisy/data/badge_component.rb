# This is the Badge component.
# @!parse class Daisy::Data::BadgeComponent < LocoMotion::BaseComponent; end
class Daisy::Data::BadgeComponent < LocoMotion.configuration.base_component_class
  set_component_name :badge

  #
  # Create a new Badge component.
  #
  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :span)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:component, "badge")
  end
end
