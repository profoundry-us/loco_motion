# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module LocoMotion
  module Algolia
    # Combines component data, documentation, and examples into search records.
    class SearchRecordBuilder
      # Initialize a new search record builder with paths to source files.
      #
      # @param root_path [String] Path to the application root
      # @param demo_path [String] Path to the demo application (for examples)
      def initialize(root_path: '.', demo_path: nil)
        require_relative 'component_indexer'
        require_relative 'documentation_extractor'
        require_relative 'example_extractor'
        
        @root_path = root_path
        @demo_path = demo_path || root_path
        @component_indexer = ComponentIndexer.new
        @documentation_extractor = DocumentationExtractor.new
        @example_extractor = ExampleExtractor.new(demo_path: @demo_path)
      end

      # Build all records for Algolia search index.
      #
      # @return [Array<Hash>] Array of records ready for Algolia indexing
      def build_records
        components = @component_indexer.extract_components
        
        # Now enrich the components with documentation and examples
        components.map do |component|
          component_name = component[:component_name]
          framework = component[:framework]
          section = component[:section]
          example_name = component[:example]
          
          # Format the example path as a URL path
          # We keep the double colons in the component name for URL matching
          example_url_path = "/examples/#{component_name}"
          component[:example_path] = example_url_path
          
          # Add documentation if available
          documentation = @documentation_extractor.extract_documentation(component_name)
          component.merge!(documentation) if documentation
          
          # Add examples if available
          example_data = @example_extractor.extract_examples(example_name, framework, section)
          component[:description] = example_data[:description] if example_data[:description]
          component[:examples] = example_data[:examples] if example_data[:examples].any?
          
          component
        end
      end
    end
  end
end
