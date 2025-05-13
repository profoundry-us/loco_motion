# frozen_string_literal: true

module Daisy
  module DataInput
    class CallyComponent < LocoMotion::BaseComponent
      include ViewComponent::SlotableDefault

      class PreviousIcon < Hero::IconComponent
        def before_render
          super

          add_html(:component, { slot: "previous" })
        end
      end

      class NextIcon < Hero::IconComponent
        def before_render
          super

          add_html(:component, { slot: "next" })
        end
      end

      class MonthComponent < LocoMotion::BaseComponent
        def initialize(**kws)
          super

          @offset = config_option(:offset)
        end

        def before_render
          super

          set_tag_name(:component, "calendar-month")
          add_html(:component, { offset: @offset }) if @offset
        end

        def call
          part(:component)
        end
      end

      define_modifiers :range

      renders_one :previous_icon, PreviousIcon
      renders_one :next_icon, NextIcon
      renders_many :months, MonthComponent

      define_parts :months

      def initialize(**kws)
        super

        # If we don't have any modifiers, assume we want a single month for a date select
        @month_count = config_option(:months, modifiers.blank? ? 1 : nil)
        @change = config_option(:change)
        @update = config_option(:update)

        @id = config_option(:id)
        @value = config_option(:value)
        @min = config_option(:min)
        @max = config_option(:max)
        @today = config_option(:today)
      end

      def before_render
        super

        if modifiers.include?(:range)
          set_tag_name(:component, "calendar-range")
        else
          set_tag_name(:component, "calendar-date")
        end

        add_css(:component, "cally")
        add_html(:component, { months: @month_count }) if @month_count

        add_html(:component, {
          id: @id,
          value: @value,
          min: @min,
          max: @max,
          today: @today
        })

        if @change
          add_html(:component, { onchange: "document.getElementById('#{@change}').value = this.value" })
        end

        if @update
          add_html(:component, { onchange: "document.getElementById('#{@update}').innerHTML = this.value" })
        end
      end

      def month_options(index)
        options = {}

        options[:offset] = index if index > 0

        options
      end

      def default_previous_icon
        PreviousIcon.new(icon: "chevron-left")
      end

      def default_next_icon
        NextIcon.new(icon: "chevron-right")
      end
    end
  end
end
