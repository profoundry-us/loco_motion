class Daisy::DataDisplay::DiffComponent < LocoMotion.configuration.base_component_class
  class ItemComponent < BasicComponent
    def set_index(index)
      @index = index
    end

    def before_render
      add_css(:component, "diff-item-#{@index}")
    end
  end

  define_part :resizer

  renders_many :items, ItemComponent

  def before_render
    add_css(:component, "diff")
    add_css(:resizer, "diff-resizer")
  end
end
