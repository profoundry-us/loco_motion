#
# Creates a component for displaying a series of steps that users can follow to
# complete a task. Useful for onboarding, form completion, and progress tracking.
#
# @note Steps are automatically numbered and connected with lines. You can use
#   colors to indicate progress through the steps.
#
# @slot steps+ {Daisy::Navigation::StepsComponent::StepComponent} The individual
#   steps to display.
#
# @example Basic steps with progress
#   = daisy_steps do |steps|
#     - steps.with_step(title: "Write Code", css: "step-primary")
#     - steps.with_step(title: "Release Code", css: "step-primary")
#     - steps.with_step(title: "Profit", css: "step-secondary")
#     - steps.with_step(title: "Rule the World")
#
# @example Vertical steps
#   = daisy_steps(css: "steps-vertical") do |steps|
#     - steps.with_step(title: "Write Code", css: "step-primary")
#     - steps.with_step(title: "Release Code", css: "step-primary")
#     - steps.with_step(title: "Profit", css: "step-secondary")
#     - steps.with_step(title: "Rule the World")
#
# @example Custom step content
#   = daisy_steps do |steps|
#     - steps.with_step(number: "AB")
#     - steps.with_step(number: "★")
#     - steps.with_step(number: "✓", css: "after:!text-green-500")
#
class Daisy::Navigation::StepsComponent < LocoMotion::BaseComponent

  #
  # A step within a StepsComponent.
  #
  # @example Basic step with title
  #   = steps.with_step(title: "Step 1")
  #
  # @example Step with custom number
  #   = steps.with_step(number: "★", title: "Special Step")
  #
  # @example Step with custom content
  #   = steps.with_step(number: "1") do
  #     .flex.gap-2
  #       = hero_icon("check")
  #       Complete
  #
  class Daisy::Navigation::StepComponent < LocoMotion::BaseComponent
    attr_reader :simple

    # Create a new instance of the StepComponent.
    #
    # @param args [Array] Not used.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws title [String] The text to display in the step.
    #
    # @option kws number [String] Custom content to display in the step's
    #   circle. Can be text, numbers, or emoji.
    #
    # @option kws css [String] Additional CSS classes for styling. Common
    #   options include:
    #   - Progress: `step-primary`, `step-secondary`, `step-accent`
    #   - Circle Content: `after:!text-green-500`, `after:!bg-black`
    #
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

  # Create a new instance of the StepsComponent.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Direction: `steps-vertical`
  #   - Size: `steps-mini`, `steps-sm`, `steps-md`, `steps-lg`
  #   - Width: `w-full`, `max-w-xs`
  #
  def initialize(**kws)
    super(**kws)
  end

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
