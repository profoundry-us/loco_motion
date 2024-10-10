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

  def call
    heroicon_tag(@icon, **rendered_html(:component))
  end
end
