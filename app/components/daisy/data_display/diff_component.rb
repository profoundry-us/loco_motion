class Daisy::DataDisplay::DiffComponent < LocoMotion.configuration.base_component_class
  class ItemComponent < BasicComponent
    def set_index(index)
      @index = index
    end

    def before_render
      # Because we're using the same component for many items, we need to
      # manually specify the item class names to make sure Tailwind picks them
      # up and includes them in the final CSS.
      #
      # diff-item-1 diff-item-2
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
