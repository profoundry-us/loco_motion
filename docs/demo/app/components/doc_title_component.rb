class DocTitleComponent < LocoMotion.configuration.base_component_class
  define_parts :title, :description

  attr_reader :simple_title

  def initialize(*args, **kws)
    super

    @simple_title = config_option(:title)
    @comp = config_option(:comp)
  end

  def before_render
    add_css(:component, "prose lg:prose-lg")

    set_tag_name(:title, :h2)
    set_tag_name(:description, :p)

    add_css(:title, "flex items-center gap-x-6")
  end

  def api_url
    comp_path = @comp.gsub("::", "/")
    "http://localhost:8808/docs/yard/#{comp_path}Component"
  end
end
