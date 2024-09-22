# The Accordion component shows sections that can be expanded or collapsed.
class Daisy::DataDisplay::AccordionComponent < LocoMotion.configuration.base_component_class

  AccordionSectionComponent = LocoMotion::BasicComponent.build do
    define_parts :radio_button, :title, :content

    renders_one :title

    # @return [String] Accessor for the `title` string passed via the component
    #   config.
    attr_reader :simple_title

    def initialize(*args, **kws, &block)
      super

      @value        = config_option(:value)
      @checked      = config_option(:checked, false)
      @simple_title = config_option(:title)
      @name         = config_option(:name)
    end

    def before_render
      setup_component
      setup_radio_button
      setup_title
      setup_content
    end

    def setup_component
      # Reset the name to the config option or the parent name if available
      @name = config_option(:name, loco_parent&.name)

      add_css(:component, "collapse")
      add_css(:component, "collapse-arrow") if loco_parent.config.modifiers.include?(:arrow)
      add_css(:component, "collapse-plus") if loco_parent.config.modifiers.include?(:plus)
    end

    def setup_radio_button
      set_tag_name(:radio_button, :input)
      add_html(:radio_button, { type: "radio", name: @name, value: @value, checked: @checked })
    end

    def setup_title
      set_tag_name(:title, :h2)
      add_css(:title, "collapse-title text-lg font-bold")
    end

    def setup_content
      add_css(:content, "collapse-content")
    end

    def call
      part(:component) do
        # Render the radio button which allows opening / closing
        concat(part(:radio_button))

        # Render the title slot, or simple title if provided
        if title?
          concat(title)
        elsif @simple_title.present?
          concat(part(:title) { @simple_title })
        end

        # Render the content
        concat(part(:content) { content })
      end
    end
  end

  define_modifiers :arrow, :plus

  renders_many :sections, AccordionSectionComponent

  attr_reader :name

  def initialize(*args, **kws, &block)
    super

    @name = config_option(:name, "accordion-#{SecureRandom.uuid}")
  end
end
