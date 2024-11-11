class Daisy::DataDisplay::CardComponent < LocoMotion::BaseComponent
  prepend LocoMotion::Concerns::TippableComponent

  Figure = LocoMotion::BasicComponent.build do
    define_part :image, tag_name: :img, css: "card-image"

    def initialize(*args, **kws, &block)
      super

      @src = kws[:src]
    end

    def before_render
      set_tag_name(:component, :figure)
      add_html(:image, src: @src) if @src
    end

    def call
      part(:component) do
        if @src
          part(:image)
        else
          content
        end
      end
    end
  end

  define_parts :body, :title

  renders_one :title, LocoMotion::BasicComponent.build(tag_name: :h2, css: "card-title")
  renders_one :top_figure, Figure
  renders_one :bottom_figure, Figure
  renders_one :actions, LocoMotion::BasicComponent.build(css: "card-actions")

  def initialize(*args, **kws, &block)
    super

    @simple_title = kws[:title]
  end

  def before_render
    setup_component
    setup_body
  end

  def setup_component
    add_css(:component, "card")
  end

  def setup_body
    add_css(:body, "card-body")
  end
end
