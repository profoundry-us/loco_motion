module Daisy
  module DataInput
    # A specialized input component that combines a text input with a calendar
    # picker. The calendar appears in a popover when the input is focused or
    # clicked.
    #
    # @part popover The container for the calendar popover.
    #
    # @slot input The text input component.
    # @slot calendar The calendar component that appears in the popover.
    #
    # @loco_example Basic Usage
    #   = daisy_cally_input(name: "event_date", value: Date.today)
    #
    # @loco_example With custom calendar and input components
    #   = daisy_cally_input(name: "event_date") do |c|
    #     = c.with_calendar(css: "custom-calendar")
    #     = c.with_input(css: "custom-input")
    class CallyInputComponent < LocoMotion::BaseComponent
      # A specialized text input component for the CallyInput that handles
      # popover targeting and data attributes needed for the Stimulus
      # controller.
      class CallyTextInputComponent < Daisy::DataInput::TextInputComponent
        # Sets up the HTML attributes needed for the text input before
        # rendering.  Configures the popover target, ID, name, and data
        # attributes required for the Stimulus controller to function properly.
        #
        # @return [void]
        def before_render
          parent_config = loco_parent.config

          # Since we're pulling options from the parent, we have to do a little
          # more work to ensure we set it up correctly.
          @start = config_option(:start, parent_config.options[:start])
          @end = config_option(:end, parent_config.options[:end])
          @floating_placeholder = config_option(:floating_placeholder, parent_config.options[:floating_placeholder])
          @floating = config_option(:floating, parent_config.options[:floating] || @floating_placeholder)
          @placeholder = config_option(:placeholder, parent_config.options[:placeholder] || @floating_placeholder)

          super

          add_html(:component, {
            popovertarget: loco_parent.popover_id,
            id: @id || loco_parent.input_id,
            name: @name || loco_parent.name,
            value: @value || parent_config.options[:value],
            placeholder: @placeholder,
            style: "anchor-name:--#{loco_parent.anchor}",
            data: {
              "cally-input-target": "input"
            }
          })
        end

        def call
          render_parent_to_string
        end
      end

      # A specialized calendar component for the CallyInput that handles the calendar
      # display and interaction within a popover.
      class CallyCalendarComponent < Daisy::DataInput::CallyComponent
        # Sets up the HTML attributes needed for the calendar before rendering.
        # Configures the ID, value, and data attributes required for the Stimulus controller.
        #
        # @return [void]
        def before_render
          super

          add_html(:component, {
            id: @id || loco_parent.calendar_id,
            value: @value || loco_parent.value,
            data: {
              "cally-input-target": "calendar"
            }
          })
        end

        def call
          render_parent_to_string
        end
      end

      include ViewComponent::SlotableDefault
      include LocoMotion::Concerns::LabelableComponent

      define_parts :popover

      renders_one :calendar, CallyCalendarComponent
      renders_one :input, CallyTextInputComponent

      attr_reader :id, :name, :value, :calendar_id, :input_id, :popover_id, :anchor, :auto_scroll_padding

      # Initializes a new CallyInputComponent.
      #
      # @param [Hash] kws The options hash
      # @option kws [String] :id A unique identifier for the input (default: auto-generated)
      # @option kws [String] :name The name attribute for the input field
      # @option kws [Date, String] :value The initial value of the input (default: nil)
      # @option kws [Integer] :auto_scroll_padding The padding to use when scrolling the calendar into view (default: 100)
      # @option kws [String] :css Additional CSS classes for the component
      def initialize(**kws)
        super(**kws)

        @id = config_option(:id, SecureRandom.uuid)
        @name = config_option(:name)
        @value = config_option(:value)
        @auto_scroll_padding = config_option(:auto_scroll_padding, 100)

        # Input ID should match our ID
        @input_id = @id

        # Other IDs / options are generated
        @calendar_id = "#{@id}-calendar"
        @popover_id = "#{@id}-popover"
        @anchor = "#{@id}-anchor"
      end

      # Sets up the component before rendering.
      # Calls the parent's before_render and then runs the component setup.
      #
      # @return [void]
      def before_render
        super

        setup_component
      end

      # Provides a default calendar component instance.
      # This is used when no custom calendar component is provided.
      #
      # @return [CallyCalendarComponent] A new instance of the default calendar component
      def default_calendar
         CallyCalendarComponent.new
      end

      # Provides a default input component instance.
      # This is used when no custom input component is provided.
      #
      # @return [CallyTextInputComponent] A new instance of the default input component
      def default_input
        CallyTextInputComponent.new
      end

      private

      # Sets up the component's HTML structure and attributes.
      # Configures the Stimulus controller and popover attributes.
      #
      # @return [void]
      # @private
      def setup_component
        # Ensure we attach the Stimulus controller
        add_stimulus_controller(:component, "cally-input")

        # Add relevant popover part HTML
        add_html(:popover, { id: @popover_id, popover: "auto", style: "position-anchor:--#{@anchor}" })
        add_html(:popover, { data: { "cally-input-target": "popover", "auto-scroll-padding": @auto_scroll_padding } })

        # Note that we NEED the dropdown class so that the anchor positioning works properly
        add_css(:popover, "where:dropdown where:bg-base-100 where:rounded where:shadow-lg")
      end
    end
  end
end
