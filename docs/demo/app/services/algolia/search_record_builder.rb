# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Algolia
  # Enriches component data with examples for Algolia search.
  #
  # This class extracts examples from component HAML files and adds them to
  # the component records to make them searchable in Algolia. It uses the
  # HamlParserService to extract examples from the demo app.
  #
  # @example
  #   builder = Algolia::SearchRecordBuilder.new(root_path: Rails.root.to_s)
  #   component, examples = builder.enrich_component(component_data)
  #
  class SearchRecordBuilder
    # Initialize a new search record builder with paths to source files.
    #
    # @param root_path [String] Path to the application root
    # @param demo_path [String] Path to the demo application (for examples)
    #
    def initialize(root_path: '.', demo_path: nil)
      require_relative 'haml_parser_service'

      @root_path = root_path
      @demo_path = demo_path || root_path
    end

    # Enrich a component record with examples
    #
    # @param component [Hash] The component record to enrich
    # @return [Array<Hash, Array>] The enriched component record and its examples
    #
    def enrich_component(component)
      component_name = component[:component_name]
      framework = component[:framework]
      section = component[:section]
      example_name = component[:example]

      # Format the example path as a URL path
      # We keep the double colons in the component name for URL matching
      example_url_path = "/examples/#{component_name}"
      component[:example_path] = example_url_path

      # Extract examples, but store them separately - don't include in the component
      example_data = extract_examples(example_name, framework, section)
      component[:description] = example_data[:description] if example_data[:description]
      
      # Return both the component and its examples
      return component, example_data[:examples] || []
    end

    private

    # Extract example usage from the demo app for a specific component.
    #
    # @param example_name [String] The name of the example file
    # @param framework [String] Optional framework name (e.g., 'daisy')
    # @param section [String] Optional section name (e.g., 'actions')
    # @return [Hash] Hash containing component description and examples
    #
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
      parser = HamlParserService.new(found_file)
      parsed_result = parser.parse

      {
        description: parsed_result[:description],
        examples: parsed_result[:examples]
      }
    rescue => e
      # Log error for debugging
      Rails.logger.debug "Error extracting examples: #{e.message}"
      Rails.logger.debug e.backtrace.join("\n") if ENV['DEBUG']
      # Return empty result if there's an error
      { description: nil, examples: [] }
    end
  end
end
