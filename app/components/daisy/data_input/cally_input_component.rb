module Daisy
  module DataInput
    class CallyInputComponent < LocoMotion::BaseComponent
      class CallyTextInputComponent < Daisy::DataInput::TextInputComponent
        def before_render
          super

          add_html(:component, {
            popovertarget: loco_parent.popover_id,
            id: loco_parent.input_id,
            style: "anchor-name:--#{loco_parent.anchor}",
            value: loco_parent.value,
            data: {
              "cally-input-target": "input"
            }
          })
        end

        def call
          render_parent_to_string
        end
      end

      class CallyCalendarComponent < Daisy::DataInput::CallyComponent
        def before_render
          super

          add_html(:component, {
            id: loco_parent.calendar_id,
            value: loco_parent.value,
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

      define_parts :popover

      renders_one :calendar, CallyCalendarComponent
      renders_one :input, CallyTextInputComponent

      attr_reader :id, :value, :calendar_id, :input_id, :popover_id, :anchor

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
        super

        setup_component
      end

      def default_calendar
         CallyCalendarComponent.new
      end

      def default_input
        CallyTextInputComponent.new(css: "default-comp")
      end

      private

      def setup_component
        add_stimulus_controller(:component, "cally-input")

        add_html(:component, { id: @id })

        add_html(:popover, { id: @popover_id, popover: "auto", style: "position-anchor:--#{@anchor}" })
        add_html(:popover, { data: { "cally-input-target": "popover" } })


        # Note that we NEED the dropdown class so that the anchor positioning works properly
        add_css(:popover, "where:dropdown where:bg-base-100 where:rounded where:shadow-lg")
      end
    end
  end
end
