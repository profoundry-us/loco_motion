module Daisy
  module DataInput
    class CallyInputComponent < LocoMotion::BaseComponent
      include ViewComponent::SlotableDefault

      define_parts :popover

      renders_one :calendar, Daisy::DataInput::CallyComponent
      renders_one :input, Daisy::DataInput::TextInputComponent

      def initialize(**kws)
        super(**kws)

        @id = config_option(:id, SecureRandom.uuid)
        @value = config_option(:value)

        @calendar_id = "#{@id}-calendar"
        @input_id = "#{@id}-input"
        @popover_id = "#{@id}-popover"
        @anchor = "#{@id}-anchor"
      end

      def before_render
        setup_component
        super # Call super after setup
      end

      def default_calendar(options = {})
        default_options = {
          id: @calendar_id,
          change: @input_id,
          value: @value
        }

        Daisy::DataInput::CallyComponent.new(**default_options.deep_merge(options))
      end

      def js_open_popover
        "document.getElementById('#{@popover_id}').togglePopover()"
      end

      def js_set_calendar_date
        [
          "(function() {",
          "  let input = document.getElementById('#{@input_id}');",
          "  let calendar = document.getElementById('#{@calendar_id}');",
          "  if (input.value.length !== 10) {return}",
          "  calendar.value = input.value;",
          "  calendar.setAttribute('focused-date', input.value);",
          "})()"
        ].join("")
      end

      def default_input(options = {})
        default_options = {
          html: {
            popovertarget: @popover_id,
            id: @input_id,
            onclick: js_open_popover.html_safe,
            onchange: js_set_calendar_date.html_safe,
            onkeyup: js_set_calendar_date.html_safe,
            style: "anchor-name:--#{@anchor}",
            value: @value
          }
        }

        Daisy::DataInput::TextInputComponent.new(**default_options.deep_merge(options))
      end

      private

      def setup_component
        add_html(:component, { id: @id })

        add_html(:popover, { id: @popover_id, popover: "auto", style: "position-anchor:--#{@anchor}" })

        # Note that we NEED the dropdown class so that the anchor positioning works properly
        add_css(:popover, "where:dropdown where:bg-base-100 where:rounded where:shadow-lg")
      end
    end
  end
end
