class DocInfoComponent < ApplicationComponent
  attr_reader :url, :image_path, :image_alt

  def initialize(*args, **kws)
    super

    @url = config_option(:url, "#")
    @image_path = config_option(:image_path, "")
    @image_alt = config_option(:image_alt, "")
  end

  def before_render
    setup_component
  end

  def setup_component
    # No additional CSS needed by default
  end
end
