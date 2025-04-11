require "active_support/concern"

module LocoMotion::Concerns::LinkableComponent
  extend ActiveSupport::Concern
  #
  # Prepend this module to enable link functionality in a component.
  # When an href is provided, the component will render as an <a> tag.
  #

  included do |base|
    base.register_component_initializer(:_initialize_linkable_component)
    base.register_component_setup(:_setup_linkable_component)
  end

  protected

  #
  # Initialize link-related options.
  #
  def _initialize_linkable_component
    @href = config_option(:href)
    @target = config_option(:target)
  end

  #
  # Sets the component's tag to <a> if an href is provided and configures the
  # appropriate HTML attributes.
  #
  def _setup_linkable_component
    if @href
      set_tag_name(:component, :a)
      add_html(:component, { href: @href, target: @target })
    end
  end
end
