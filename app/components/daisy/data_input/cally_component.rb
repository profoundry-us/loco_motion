# frozen_string_literal: true

module Daisy
  module DataInput
    # The Cally component provides a customizable calendar interface for date selection.
    # It supports both single date and date range selection, with configurable display
    # options including the number of months to show and navigation controls.
    #
    # @part component The root calendar element that contains all other parts.
    # @part months The container element that holds the month components.
    #
    # @slot previous_icon [PreviousIcon] The icon used for navigating to the
    #   previous month. Defaults to a chevron-left icon.
    #   @see #default_previous_icon
    # @slot next_icon [NextIcon] The icon used for navigating to the next month.
    #   Defaults to a chevron-right icon.
    #   @see #default_next_icon
    # @slot months+ [MonthComponent] The month components to display in the calendar.
    #   Multiple months can be displayed side by side.
    #   @see #month_options
    #
    # @loco_example Basic calendar with default options
    #   = daisy_cally
    #
    # @loco_example Calendar with range selection enabled
    #   = daisy_cally(modifier: :range)
    #
    # @loco_example Calendar showing multiple months with custom value
    #   = daisy_cally(months: 2, value: Date.today)
    #
    # @loco_example Calendar with min/max date constraints
    #   = daisy_cally(min: 1.month.ago, max: 1.month.from_now)
    class CallyComponent < LocoMotion::BaseComponent
      include ViewComponent::SlotableDefault

      # A component for the previous navigation icon in the calendar header.
      #
      # @note This is used internally by CallyComponent
      class PreviousIcon < Hero::IconComponent
        def before_render
          super

          add_html(:component, { slot: "previous" })
        end
      end

      # A component for the next navigation icon in the calendar header.
      #
      # @note This is used internally by CallyComponent
      class NextIcon < Hero::IconComponent
        def before_render
          super

          add_html(:component, { slot: "next" })
        end
      end

      # A component representing a single month in the calendar.
      #
      # @note This is used internally by CallyComponent
      class MonthComponent < LocoMotion::BaseComponent
        # @param offset [Integer, nil] The offset of this month from the start date
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

      # Initializes a new CallyComponent.
      #
      # The Cally component provides a customizable calendar interface for date
      # selection.  It supports single date selection by default and can be
      # configured for date range selection.  The component automatically
      # handles navigation between months and can display multiple months.
      #
      # @param change [String] ID of an input to update with the selected date
      # @param update [String] ID of an element to update with the selected date
      # @param id [String] The ID of the calendar element
      # @param value [String, Date] The currently selected date or range
      # @param min [String, Date] The minimum selectable date
      # @param max [String, Date] The maximum selectable date
      # @param today [String, Date] The date to consider as 'today'
      # @param months [Integer] Number of months to display (default: 1)
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

      # Configures the calendar component before rendering.
      #
      # Sets up the appropriate tag name based on whether range selection is
      # enabled, adds CSS classes, and configures HTML attributes for the
      # calendar component.
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

      # Generates options for a month component at the given index.
      #
      # @param index [Integer] The 0-based index of the month
      # @return [Hash] Options hash for the month component
      def month_options(index)
        options = {}

        options[:offset] = index if index > 0

        options
      end

      # Provides a default previous icon if none is specified.
      #
      # @return [PreviousIcon] A chevron-left icon
      def default_previous_icon
        PreviousIcon.new(icon: "chevron-left")
      end

      # Provides a default next icon if none is specified.
      #
      # @return [NextIcon] A chevron-right icon
      def default_next_icon
        NextIcon.new(icon: "chevron-right")
      end
    end
  end
end
