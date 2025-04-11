module LocoMotion::Concerns::LinkableComponent
  #
  # Prepend this module to enable link functionality in a component.
  # When an href is provided, the component will render as an <a> tag.
  #

  #
  # Initialize link-related options.
  #
  def initialize_linkable_component
    @href = config_option(:href)
    @target = config_option(:target)
  end

  #
  # Sets the component's tag to <a> if an href is provided and configures the
  # appropriate HTML attributes.
  #
  def setup_linkable_component
    if @href
      set_tag_name(:component, :a)
      add_html(:component, { href: @href, target: @target })
    end
  end
end
