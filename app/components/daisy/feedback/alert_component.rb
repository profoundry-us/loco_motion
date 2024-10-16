#
# The AlertComponent displays an important message to users.
#
class Daisy::Feedback::AlertComponent < LocoMotion.configuration.base_component_class
  define_parts :icon, :content_wrapper

  def initialize(*args, **kws, &block)
    super

    @icon = config_option(:icon)
  end

  def before_render
    add_css(:component, "alert")
    add_html(:component, { role: "alert" })

    add_css(:icon, "[:where(&)]:size-8")
  end
end
