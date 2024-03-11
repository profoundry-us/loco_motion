# This is the Badge component.
# @!parse class LocoMotion::Data::BadgeComponent < LocoMotion::BaseComponent; end
class LocoMotion::Data::BadgeComponent < LocoMotion.configuration.base_component_class
  set_component_name :badge

  define_sizes :xs, :sm, :lg, :xl

  define_variants :neutral, :primary, :secondary, :accent, :ghost
  define_variants :info, :success, :warning, :error
  define_variant :outline

  #
  # Create a new Badge component.
  #
  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component, :span)
  end
end
