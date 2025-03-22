# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module LocoMotion
  module Algolia
    # Extracts and formats component data from LocoMotion helpers for Algolia indexing.
    #
    # This service is responsible for gathering all component data defined in the
    # LocoMotion::COMPONENTS hash and formatting it for indexing in Algolia.
    class ComponentIndexer
      # Initialize a new component indexer.
      # 
      # If components_data is not provided, it will attempt to load the data
      # from LocoMotion::COMPONENTS if available.
      #
      # @param components_data [Hash, nil] Optional hash of component data to index
      # @param root_path [String] Path to the application root
      # @param demo_path [String] Path to the demo application (for examples)
      def initialize(components_data = nil, root_path: '.', demo_path: nil)
        require_relative 'search_record_builder'
        
        @components = components_data || load_components_data
        @root_path = root_path
        @demo_path = demo_path || root_path
        @search_record_builder = SearchRecordBuilder.new(root_path: @root_path, demo_path: @demo_path)
      end

      # Extract and enrich component data for Algolia indexing.
      #
      # @return [Array<Hash>] Array of component records for indexing
      def build_search_records
        base_components = extract_components
        
        # Enrich each component with examples
        base_components.map do |component|
          @search_record_builder.enrich_component(component)
        end
      end
      
      # Extract component data from the LocoMotion::COMPONENTS hash.
      #
      # @return [Array<Hash>] Array of basic component records
      def extract_components
        @components.map do |component_name, metadata|
          build_component_record(component_name, metadata)
        end
      end

      private

      # Load components data from LocoMotion::COMPONENTS if available
      # Otherwise return an empty hash
      #
      # @return [Hash] Component data hash
      def load_components_data
        if defined?(LocoMotion) && defined?(LocoMotion::COMPONENTS)
          LocoMotion::COMPONENTS
        else
          {}
        end
      end

      # Build a searchable record for a component.
      #
      # @param component_name [String] The fully qualified component name
      # @param metadata [Hash] The component metadata from LocoMotion::COMPONENTS
      # @return [Hash] The formatted component record
      def build_component_record(component_name, metadata)
        names = [metadata[:names]].flatten.compact
        path_parts = component_name.split('::')
        framework = path_parts.first.downcase
        section = path_parts.length > 2 ? path_parts[1] : nil
        component_class = path_parts.last

        {
          objectID: component_name,
          component_name: component_name,
          class_name: component_class,
          framework: framework,
          section: section,
          group: metadata[:group],
          title: metadata[:title],
          example: metadata[:example],
          helper_names: names.map { |name| "#{framework}_#{name}" },
          example_path: component_example_path(component_name, metadata),
          popularity: calculate_popularity(component_name, metadata)
        }
      end

      # Generate example path for a component
      # This reimplements the logic from LocoMotion::Helpers.component_example_path
      # to avoid requiring the full Rails environment
      #
      # @param component_name [String] The component name
      # @param metadata [Hash] The component metadata
      # @return [String] The example path
      def component_example_path(component_name, metadata)
        comp_split = component_name.split("::") 
        framework = comp_split.first.underscore
        section = comp_split.length == 3 ? comp_split[1] : nil
        example = metadata[:example]
        section_path = section ? "#{section.underscore}/" : ""

        "/examples/#{framework}/#{section_path}#{example}"
      end

      # Calculate a popularity score for a component.
      # This is a placeholder implementation that can be refined over time.
      #
      # @param component_name [String] The fully qualified component name
      # @param metadata [Hash] The component metadata
      # @return [Integer] A popularity score (higher is more popular)
      def calculate_popularity(component_name, metadata)
        # Simple popularity calculation - could be enhanced later
        # with actual usage data, view counts, etc.
        score = 50 # Base score

        # Prioritize common components
        common_components = [
          'Button', 'Card', 'Modal', 'Alert', 'Tabs', 'Form', 
          'Select', 'TextInput', 'Checkbox'
        ]
        
        common_components.each do |common|
          score += 10 if component_name.include?(common)
        end

        # Multiple helper methods might indicate a more versatile component
        names = [metadata[:names]].flatten.compact
        score += names.size * 10

        score
      end
    end
  end
end
