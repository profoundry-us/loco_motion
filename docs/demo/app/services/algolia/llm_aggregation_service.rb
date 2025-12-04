# frozen_string_literal: true

module Algolia
  # Service for aggregating component data for LLM.txt export
  #
  # This service collects and structures component documentation in a format
  # optimized for LLM consumption, grouping data by component rather than
  # flattening into search records.
  #
  # @loco_example Aggregate all components
  #   service = Algolia::LLMAggregationService.new
  #   components = service.aggregate_all
  #
  # @loco_example Aggregate a single component
  #   service = Algolia::LLMAggregationService.new
  #   component = service.aggregate_component("Daisy::Actions::ButtonComponent", 0)
  #
  class LlmAggregationService
    # Initialize the aggregation service
    #
    def initialize
    end

    # Aggregate all components from the registry
    #
    # @return [Array<Hash>] Array of component data bundles
    #
    def aggregate_all
      Rails.logger.debug "Aggregating all components from registry..."

      components = []
      LocoMotion::COMPONENTS.keys.each_with_index do |component_name, position|
        component_data = aggregate_component(component_name, position)
        components << component_data if component_data
      end

      Rails.logger.debug "Aggregated #{components.length} components"
      components
    end

    # Aggregate a single component
    #
    # @param component_name [String] The fully qualified component name
    # @param position [Integer] The position in the component list (for stable ordering)
    #
    # @return [Hash, nil] Component data bundle or nil if file not found
    #
    def aggregate_component(component_name, position = 0)
      Rails.logger.debug "Aggregating component: #{component_name}"

      metadata = LocoMotion::COMPONENTS[component_name]
      return nil unless metadata

      split = component_name.split('::')
      framework = split[0]
      section = split.length == 3 ? split[1] : ""
      base_name = split.last

      # Construct file path
      framework_path = framework.underscore
      group_path = section.present? ? "#{section.underscore}/" : ""
      example_name = metadata[:example]
      file_path = Rails.root.join('app', 'views', 'examples', framework_path, group_path, "#{example_name}.html.haml").to_s

      # Check if file exists
      unless File.exist?(file_path)
        Rails.logger.debug "File not found: #{file_path}"
        return nil
      end

      # Parse the file
      parser = Algolia::HamlParserService.new(file_path)
      parsed = parser.parse

      # Build URLs
      examples_url = "https://loco-motion.profoundry.us#{LocoMotion::Helpers.component_example_path(component_name)}"
      api_url = "https://loco-motion.profoundry.us/api-docs"

      # Build GitHub URL for the component file
      # e.g. https://github.com/profoundry-us/loco_motion/blob/main/app/components/daisy/actions/button_component.rb
      github_path = component_name.underscore + ".rb"
      github_url = "https://github.com/profoundry-us/loco_motion/blob/main/app/components/#{github_path}"

      # Return normalized structure
      {
        component: component_name,
        framework: framework,
        section: section,
        base_name: base_name,
        examples_url: examples_url,
        api_url: api_url,
        file_path: github_url,
        title: parsed[:title],
        description: parsed[:description],
        examples: parsed[:examples],
        position: position
      }
    end
  end
end
