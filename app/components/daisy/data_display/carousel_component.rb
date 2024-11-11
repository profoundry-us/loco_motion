class Daisy::DataDisplay::CarouselComponent < LocoMotion::BaseComponent
  class ItemComponent < LocoMotion::BasicComponent
    def before_render
      add_css(:component, "carousel-item")
    end
  end

  renders_many :items, ItemComponent

  def before_render
    setup_component
  end

  def setup_component
    add_css(:component, "carousel")
  end
end
