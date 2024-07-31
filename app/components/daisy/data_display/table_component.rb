class Daisy::DataDisplay::TableComponent < LocoMotion.configuration.base_component_class
  set_component_name :table

  define_parts :table_head, :table_body, :header, :row, :wrapper

  renders_one :component
  
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
    add_html(:component, "table")
  end
end
