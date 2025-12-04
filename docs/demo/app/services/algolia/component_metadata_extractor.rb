# frozen_string_literal: true

module Algolia
  # Service for extracting metadata from component classes
  #
  # This service uses Ruby introspection to extract API signatures,
  # component relationships, and Rails integration information.
  #
  # @loco_example Extract metadata for a component
  #   extractor = Algolia::ComponentMetadataExtractor.new
  #   metadata = extractor.extract_for_component("Daisy::Actions::ButtonComponent")
  #
  class ComponentMetadataExtractor
    # Initialize the metadata extractor
    #
    def initialize
    end

    # Extract comprehensive metadata for a component
    #
    # @param component_name [String] The fully qualified component name
    #
    # @return [Hash] Component metadata including API signature, relationships, etc.
    #
    def extract_for_component(component_name)
      begin
        component_class = component_name.constantize
      rescue NameError
        return { error: "Component class not found" }
      end

      {
        api_signature: extract_api_signature(component_class, component_name),
        related_components: find_related_components(component_name),
        rails_integration: extract_rails_integration(component_class),
        component_category: extract_category_info(component_name)
      }
    end

    # Extract library-wide metadata
    #
    # @return [Hash] Library metadata for the header section
    #
    def extract_library_metadata
      component_count = LocoMotion::COMPONENTS.keys.length
      categories = extract_all_categories

      {
        framework: "Ruby on Rails + ViewComponent",
        ui_library: "DaisyUI v5",
        total_components: component_count,
        component_categories: categories,
        helper_prefixes: ["daisy_", "hero_"],
        file_conventions: {
          components: "app/components/",
          examples: "app/views/examples/",
          helpers: "lib/loco_motion/helpers.rb"
        }
      }
    end

    private

    # Extract API signature from component class
    #
    # @param component_class [Class] The component class
    # @param component_name [String] The component name
    #
    # @return [Hash] API signature information
    #
    def extract_api_signature(component_class, component_name)
      # Get helper method names from registry
      metadata = LocoMotion::COMPONENTS[component_name]
      helper_names = metadata && metadata[:names] ? [metadata[:names]].flatten.compact : []

      # Try to get the initialize method signature
      signature = analyze_initialize_method(component_class)

      {
        helper_methods: helper_names.map { |name| "#{component_name.split('::').first.underscore}_#{name}" },
        initialize_signature: signature,
        common_parameters: extract_common_parameters(component_class)
      }
    end

    # Analyze the initialize method of a component
    #
    # @param component_class [Class] The component class
    #
    # @return [String] Method signature as string
    #
    def analyze_initialize_method(component_class)
      return "initialize()" unless component_class.method_defined?(:initialize)

      method = component_class.instance_method(:initialize)
      params = method.parameters

      param_list = params.map do |type, name|
        case type
        when :req
          name.to_s
        when :opt
          "#{name} = nil"
        when :keyreq
          "#{name}:"
        when :key
          "#{name}: nil"
        else
          name.to_s
        end
      end

      "initialize(#{param_list.join(', ')})"
    rescue => e
      Rails.logger.debug "Error analyzing initialize method: #{e.message}"
      "initialize()"
    end

    # Extract common parameters from component examples
    #
    # @param component_class [Class] The component class
    #
    # @return [Array<Hash>] Common parameters with descriptions
    #
    def extract_common_parameters(component_class)
      # Common parameters across most components
      common_params = [
        { name: "css", type: "String", description: "CSS classes for styling" },
        { name: "html", type: "Hash", description: "HTML attributes" }
      ]

      # Add component-specific parameters based on class analysis
      if component_class.method_defined?(:initialize)
        method = component_class.instance_method(:initialize)
        params = method.parameters

        params.each do |type, name|
          next if [:block].include?(type)

          param_info = {
            name: name.to_s,
            type: infer_parameter_type(name, type),
            description: infer_parameter_description(name)
          }

          common_params << param_info unless common_params.any? { |p| p[:name] == name.to_s }
        end
      end

      common_params
    rescue => e
      Rails.logger.debug "Error extracting parameters: #{e.message}"
      []
    end

    # Find related components based on category and usage patterns
    #
    # @param component_name [String] The component name
    #
    # @return [Array<String>] List of related component names
    #
    def find_related_components(component_name)
      metadata = LocoMotion::COMPONENTS[component_name]
      return [] unless metadata

      section = metadata[:group]
      related = []

      # Find components in the same section
      LocoMotion::COMPONENTS.each do |name, meta|
        if meta[:group] == section && name != component_name
          related << name
        end
      end

      # Add commonly used together components based on patterns
      related += find_pattern_relationships(component_name)

      related.uniq.first(5) # Limit to 5 most relevant
    end

    # Find relationships based on common usage patterns
    #
    # @param component_name [String] The component name
    #
    # @return [Array<String>] Related components based on usage patterns
    #
    def find_pattern_relationships(component_name)
      relationships = {
        # Form components
        "Daisy::DataInput::LabelComponent" => ["Daisy::DataInput::TextInputComponent", "Daisy::DataInput::SelectComponent"],
        "Daisy::DataInput::TextInputComponent" => ["Daisy::DataInput::LabelComponent", "Daisy::Feedback::AlertComponent"],
        "Daisy::DataInput::SelectComponent" => ["Daisy::DataInput::LabelComponent"],
        "Daisy::DataInput::TextAreaComponent" => ["Daisy::DataInput::LabelComponent"],

        # Navigation components
        "Daisy::Navigation::NavbarComponent" => ["Daisy::Navigation::LinkComponent"],
        "Daisy::Navigation::BreadcrumbsComponent" => ["Daisy::Navigation::LinkComponent"],

        # Layout components
        "Daisy::Layout::HeroComponent" => ["Daisy::Actions::ButtonComponent"],
        "Daisy::Layout::CardComponent" => ["Daisy::Actions::ButtonComponent"],

        # Feedback components
        "Daisy::Feedback::AlertComponent" => ["Daisy::DataInput::TextInputComponent"],
        "Daisy::Feedback::TooltipComponent" => ["Daisy::Actions::ButtonComponent"]
      }

      relationships[component_name] || []
    end

    # Extract Rails integration information
    #
    # @param component_class [Class] The component class
    #
    # @return [Hash] Rails integration details
    #
    def extract_rails_integration(component_class)
      {
        base_class: component_class.ancestors.find { |a| a.name&.include?("Component") }&.name,
        includes: extract_included_modules(component_class),
        view_component: component_class.ancestors.any? { |a| a.name == "ViewComponent::Base" },
        helper_methods: extract_helper_methods(component_class)
      }
    end

    # Extract category information for a component
    #
    # @param component_name [String] The component name
    #
    # @return [Hash] Category information
    #
    def extract_category_info(component_name)
      metadata = LocoMotion::COMPONENTS[component_name]
      return {} unless metadata

      {
        group: metadata[:group],
        title: metadata[:title],
        example: metadata[:example]
      }
    end

    # Extract all categories from the component registry
    #
    # @return [Array<String>] List of component categories
    #
    def extract_all_categories
      categories = LocoMotion::COMPONENTS.values.map { |meta| meta[:group] }.uniq
      categories.sort
    end

    # Extract included modules from a component class
    #
    # @param component_class [Class] The component class
    #
    # @return [Array<String>] List of included module names
    #
    def extract_included_modules(component_class)
      component_class.included_modules
        .select { |mod| mod.name&.start_with?("LocoMotion") }
        .map(&:name)
    rescue
      []
    end

    # Extract helper methods from a component class
    #
    # @param component_class [Class] The component class
    #
    # @return [Array<String>] List of helper method names
    #
    def extract_helper_methods(component_class)
      return [] unless component_class.respond_to?(:helper_method)

      # This is a simplified approach - in practice, helper detection is more complex
      component_class.public_instance_methods(false).map(&:to_s)
    rescue
      []
    end

    # Infer parameter type from name and parameter type
    #
    # @param name [Symbol] Parameter name
    # @param type [Symbol] Parameter type (:req, :opt, :keyreq, :key)
    #
    # @return [String] Inferred type
    #
    def infer_parameter_type(name, type)
      case name
      when :css, :class, :style
        "String"
      when :html, :data, :aria
        "Hash"
      when :icon, :left_icon, :right_icon
        "String"
      when :tip, :title
        "String"
      else
        case type
        when :key, :keyreq
          "Keyword"
        else
          "Object"
        end
      end
    end

    # Infer parameter description from name
    #
    # @param name [Symbol] Parameter name
    #
    # @return [String] Inferred description
    #
    def infer_parameter_description(name)
      case name
      when :css
        "CSS classes for styling"
      when :html
        "HTML attributes"
      when :class
        "CSS class names"
      when :style
        "Inline CSS styles"
      when :data
        "Data attributes"
      when :aria
        "ARIA attributes for accessibility"
      when :icon, :left_icon, :right_icon
        "Icon name from Heroicons"
      when :tip
        "Tooltip text"
      when :title
        "Element title"
      else
        "Component parameter"
      end
    end
  end
end
