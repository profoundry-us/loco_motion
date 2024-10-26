class Hero::IconComponent < LocoMotion.configuration.base_component_class
  def initialize(*args, **kws, &block)
    super

    # Accept either the :icon keyword argument or the first positional argument
    @icon = config_option(:icon, args[0])
    @variant = config_option(:variant)
  end

  def before_render
    add_html(:component, { variant: @variant }) if @variant
    add_css(:component, "[:where(&)]:size-5")
  end

  #
  # Renders the icon component.
  #
  # Because this is an inline component which might be utlized alongside text,
  # we utilize the `call` method instead of a template to ensure that no
  # additional whitespace gets added to the output.
  #
  def call
    heroicon_tag(@icon, **rendered_html(:component))
  end
end
