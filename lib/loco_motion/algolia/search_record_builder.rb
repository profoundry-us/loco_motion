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
        require_relative 'haml_parser_service'
        
        @root_path = root_path
        @demo_path = demo_path || root_path
        @component_indexer = ComponentIndexer.new
        @documentation_extractor = DocumentationExtractor.new
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
          example_data = extract_examples(example_name, framework, section)
          component[:description] = example_data[:description] if example_data[:description]
          component[:examples] = example_data[:examples] if example_data[:examples].any?
          
          component
        end
      end
      
      private
      
      # Extract example usage from the demo app for a specific component.
      #
      # @param example_name [String] The name of the example file
      # @param framework [String] Optional framework name (e.g., 'daisy')
      # @param section [String] Optional section name (e.g., 'actions')
      # @return [Hash] Hash containing component description and examples
      def extract_examples(example_name, framework = nil, section = nil)
        return { description: nil, examples: [] } unless example_name

        # Build the path to the example file
        path_parts = []
        path_parts << framework.underscore if framework
        path_parts << section.underscore if section
        path_parts << example_name

        example_path = File.join(
          @demo_path,
          'app',
          'views',
          'examples',
          *path_parts
        )

        # We only need 1 extension for now, but we'll future-proof this if we
        # have a different example file later
        extensions = ['.html.haml']
        found_file = nil

        extensions.each do |ext|
          potential_file = "#{example_path}#{ext}"
          if File.exist?(potential_file)
            found_file = potential_file
            break
          end
        end

        # If no file was found, return empty array
        return { description: nil, examples: [] } unless found_file

        # Use the HamlParserService to parse the file
        debug_mode = ENV['DEBUG'] == 'true'
        parser = HamlParserService.new(found_file, debug_mode)
        parsed_result = parser.parse

        # Format the result to match our expected output structure
        enhanced_examples = parsed_result[:examples].map do |example|
          {
            title: "#{framework.capitalize} #{section&.capitalize} - #{example[:title]}",
            description: example[:description] || "",
            code: example[:code]
          }
        end

        {
          description: parsed_result[:description],
          examples: enhanced_examples
        }
      rescue => e
        # Log error for debugging
        puts "Error extracting examples: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        # Return empty result if there's an error
        { description: nil, examples: [] }
      end
    end
  end
end
