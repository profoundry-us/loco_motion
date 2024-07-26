class Daisy::DataDisplay::TableComponent < LocoMotion.configuration.base_component_class
  set_component_name :table

  define_parts :head, :body, :header, :row, :wrapper

  def initialize(*args, **kws, &block)
    super

    set_tag_name(:component)
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    add_css(:wrapper, "overflow-x-auto")
    add_css(:component, "table")
  end
end
