class Daisy::Navigation::BreadcrumbsComponent < LocoMotion.configuration.base_component_class
  define_parts :list_wrapper

  renders_many :items, LocoMotion::BasicComponent.build(tag_name: :li)

  def initialize(*args, **kws, &block)
    super
  end

  def before_render
    add_css(:component, "breadcrumbs")

    set_tag_name(:list_wrapper, :ul)
  end
end
