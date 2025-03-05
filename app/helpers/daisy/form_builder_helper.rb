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

          # Pass the form builder's object to the component if it exists
          if @object && @object.respond_to?(name) && !options.key?(:checked)
            options[:checked] = @object.send(name)
          end

          # Render the checkbox component
          @template.daisy_checkbox(name: "#{object_name}[#{name}]", **options)
        end

        # Add the daisy_radio method to FormBuilder
        def daisy_radio(name, **options)
          # Get the object name from the form builder
          object_name = @object_name.to_s

          # Create a unique ID if not provided
          value = options[:value].to_s
          options[:id] ||= "#{object_name}_#{name}_#{value}"

          # Pass the form builder's object to the component if it exists
          if @object && @object.respond_to?(name) && !options.key?(:checked)
            options[:checked] = (@object.send(name).to_s == value)
          end

          # Render the radio button component
          @template.daisy_radio(name: "#{object_name}[#{name}]", **options)
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
      end
    end
  end
end

# Include the FormBuilderHelper in ActionView::Helpers::FormBuilder
ActionView::Helpers::FormBuilder.include(Daisy::FormBuilderHelper)
