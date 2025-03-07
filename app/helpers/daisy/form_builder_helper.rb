# frozen_string_literal: true

module Daisy
  module FormBuilderHelper
    # Extends ActionView::Helpers::FormBuilder with Daisy UI component methods
    def self.included(base)
      base.class_eval do
        # Add the daisy_checkbox method to FormBuilder
        def daisy_checkbox(name, **options)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a unique ID if not provided
          options[:id] ||= "#{object_name}_#{name}"

          # Set the name attribute
          options[:name] = "#{object_name}[#{name}]"

          # Pass the form builder's object to the component if it exists
          if @object && @object.respond_to?(name) && !options.key?(:checked)
            options[:checked] = @object.send(name)
          end

          # Render the checkbox component
          @template.daisy_checkbox(**options)
        end

        # Add the daisy_toggle method to FormBuilder
        def daisy_toggle(name, **options)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a unique ID if not provided
          options[:id] ||= "#{object_name}_#{name}"

          # Set the name attribute
          options[:name] = "#{object_name}[#{name}]"

          # Pass the form builder's object to the component if it exists
          if @object && @object.respond_to?(name) && !options.key?(:checked)
            options[:checked] = @object.send(name)
          end

          # Render the toggle component
          @template.daisy_toggle(**options)
        end

        # Add the daisy_radio method to FormBuilder
        def daisy_radio(name, **options)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a unique ID if not provided
          value = options[:value].to_s
          options[:id] ||= "#{object_name}_#{name}_#{value}"

          # Set the name attribute
          options[:name] = "#{object_name}[#{name}]"

          # Pass the form builder's object to the component if it exists
          if @object && @object.respond_to?(name) && !options.key?(:checked)
            options[:checked] = @object.send(name).to_s == value
          end

          # Render the radio button component
          @template.daisy_radio(**options)
        end

        # Add the daisy_label method to FormBuilder
        def daisy_label(name, text = nil, **options, &block)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a for_id based on the name if not provided
          options[:for] ||= "#{object_name}_#{name}"

          # Add a humanized title from the name if not provided
          options[:title] ||= text || name.to_s.humanize

          # Render the label component
          @template.daisy_label(**options, &block)
        end

        # Add the daisy_range method to FormBuilder
        def daisy_range(method, **options)
          render_daisy_component(Daisy::DataInput::RangeComponent, method, **options)
        end

        # Add the daisy_rating method to FormBuilder
        def daisy_rating(method, **options)
          render_daisy_component(Daisy::DataInput::RatingComponent, method, **options)
        end

        # Add the daisy_file_input method to FormBuilder
        def daisy_file_input(method, **options)
          render_daisy_component(Daisy::DataInput::FileInputComponent, method, **options)
        end

        # Add the daisy_select method to FormBuilder
        def daisy_select(method, options: nil, option_groups: nil, placeholder: nil,
                          options_css: nil, options_html: {}, **args, &block)
          # Extract the name from the form builder's object_name and method
          name = "#{object_name}[#{method}]"

          # Get the current value from the object
          value = object.try(method)

          # Generate a default ID if not provided
          id = args[:id] || "#{object_name}_#{method}"

          # Build the component with the extracted form values and any additional options
          @template.daisy_select(
            name: name,
            id: id,
            value: value,
            options: options,
            options_css: options_css,
            options_html: options_html,
            placeholder: placeholder,
            **args,
            &block
          )
        end

        private

        def render_daisy_component(component_class, method, **options)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a unique ID if not provided
          options[:id] ||= "#{object_name}_#{method}"

          # Set the name attribute
          options[:name] ||= "#{object_name}[#{method}]"

          # Pass the form builder's object to the component if it exists
          options[:value] ||= object.try(method)

          # Render the component
          @template.render component_class.new(**options)
        end
      end
    end
  end
end

# Include the FormBuilderHelper in ActionView::Helpers::FormBuilder
ActionView::Helpers::FormBuilder.include(Daisy::FormBuilderHelper)
