#
# The Accordion component shows collapsible sections of content, with only one
# section open at a time. Each section has a title that can be clicked to show
# or hide its content.
#
# Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
# tooltip addition.
#
# @slot section+ Multiple sections that can be expanded or collapsed. Each
#   section can have a title and content.
#
# @loco_example Basic Usage
#   = daisy_accordion do |accordion|
#     - accordion.with_section(title: "Section 1") do
#       This is the content of section 1
#     - accordion.with_section(title: "Section 2") do
#       This is the content of section 2
#
# @loco_example With Arrow Icons
#   = daisy_accordion(:arrow) do |accordion|
#     - accordion.with_section(title: "Section 1") do
#       This is the content of section 1
#     - accordion.with_section(title: "Section 2") do
#       This is the content of section 2
#
# @loco_example With Plus Icons
#   = daisy_accordion(:plus) do |accordion|
#     - accordion.with_section(title: "Section 1") do
#       This is the content of section 1
#     - accordion.with_section(title: "Section 2") do
#       This is the content of section 2
#
# @loco_example With Custom Title Content
#   = daisy_accordion do |accordion|
#     - accordion.with_section do |section|
#       - section.with_title do
#         .flex.items-center.gap-2
#           = heroicon_tag "star"
#           Featured Section
#       This is the content of the featured section
#
class Daisy::DataDisplay::AccordionComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::TippableComponent

  # Renders a single section of the accordion.
  #
  # @part radio_button The radio input that controls the section's state.
  # @part title The title bar that can be clicked to expand/collapse the section.
  # @part content The container for the section's content.
  #
  # @slot title Custom content for the section's title bar.
  #
  class AccordionSectionComponent < LocoMotion::BasicComponent
    define_parts :radio_button, :title, :content

    renders_one :title

    # @return [String] Accessor for the `title` string passed via the component
    #   config.
    attr_reader :simple_title

    # Creates a new accordion section.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws title [String] The text to display in the section's title bar.
    #   You can also provide a custom title content using the title slot.
    #
    # @option kws value [String] The value for the radio button that controls
    #   this section. Defaults to a random string.
    #
    # @option kws checked [Boolean] Whether this section should start expanded.
    #   Defaults to false.
    #
    # @option kws name [String] The name attribute for the radio button group.
    #   Usually provided by the parent accordion.
    #
    def initialize(**kws, &block)
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
      @name = config_option(:name, loco_parent.name)

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

  # @return [String] The name attribute for all radio buttons in this accordion.
  attr_reader :name

  #
  # Creates a new accordion component.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for all radio buttons in this
  #   accordion. Defaults to a random string.
  #
  # @option kws modifier [Symbol] Optional modifier for the accordion's appearance.
  #   Use `:arrow` to show arrow indicators, or `:plus` to show plus/minus
  #   indicators.
  #
  # @option kws tip [String] The tooltip text to display when hovering over
  #   the component.
  #
  def initialize(**kws, &block)
    super

    @name = config_option(:name, "accordion-#{SecureRandom.uuid}")
  end

  def before_render
    super
  end
end
