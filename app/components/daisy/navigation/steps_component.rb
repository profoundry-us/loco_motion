class Daisy::Navigation::StepsComponent < LocoMotion::BaseComponent

  class Daisy::Navigation::StepComponent < LocoMotion::BaseComponent
    attr_reader :simple
    def initialize(*args, **kws, &block)
      super

      @simple_title = config_option(:title)
      @number = config_option(:number)
    end

    def before_render
      set_tag_name(:component, :li)
      add_css(:component, "step")
      add_html(:component, { data: { content: @number } }) if @number
    end

    def call
      part(:component) do
        concat(@simple_title) if @simple_title
        concat(content) if content?
      end
    end
  end

  renders_many :steps, Daisy::Navigation::StepComponent

  def before_render
    set_tag_name(:component, :ul)
    add_css(:component, "steps")
  end

  def call
    part(:component) do
      steps.each do |step|
        concat(step)
      end
    end
  end
end
