class Daisy::Mockup::DeviceComponent < LocoMotion::BaseComponent

  define_parts :camera, :display

  def initialize(*args, **kws, &block)
    super

    @show_camera = config_option(:show_camera, true)
  end

  def before_render
    add_css(:camera, "camera")
    add_css(:display, "display")
    add_css(:display, "!mt-0") if !@show_camera
  end

  def call
    part(:component) do
      concat(part(:camera)) if @show_camera

      concat(part(:display) do
        content
      end)
    end
  end

end
