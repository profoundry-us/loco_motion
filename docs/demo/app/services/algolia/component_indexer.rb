# frozen_string_literal: true

module Algolia
  # Indexes LocoMotion components into Algolia for searching
  #
  # This service builds search records from each component in the LocoMotion library
  # and prepares them for indexing into Algolia.
  #
  # @example
  #   indexer = Algolia::ComponentIndexer.new
  #   records = indexer.build_search_records
  #   client.index('components').save_objects(records)
  #
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

        # Collect all components and examples
        enriched_components = []
        all_examples = []

        # Process each component
        base_components.each do |component|
          # Get the enriched component and its examples
          enriched_component, examples = @search_record_builder.enrich_component(component)
          enriched_components << enriched_component

          # Process examples if any
          examples.each do |example|
            # Create a unique ID for the example
            example_id = "#{component[:objectID]}:#{example[:anchor]}"

            # Create a record for this example with type as the first attribute
            example_record = {
              type: 'example',
              objectID: example_id,
              component_name: component[:component_name],
              component_objectID: component[:objectID],
              framework: component[:framework],
              section: component[:section],
              group: component[:group],
              example_path: component[:example_path],
              title: example[:title],
              anchor: example[:anchor],
              description: example[:description],
              code: example[:code]
            }

            all_examples << example_record
          end
        end

        # Reorder component attributes to ensure type is first
        ordered_components = enriched_components.map do |component|
          {
            type: 'component',
            objectID: component[:objectID],
          }.merge(component.except(:type))
        end

        # Return both the components and the examples as top-level records
        ordered_components + all_examples
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
          type: 'component',
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
