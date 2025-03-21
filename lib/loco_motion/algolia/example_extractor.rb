# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module LocoMotion
  module Algolia
    # Extracts example usage from the demo app for search results.
    class ExampleExtractor
      # Initialize a new example extractor.
      #
      # @param demo_path [String] Path to the demo application
      def initialize(demo_path: nil)
        @demo_path = demo_path || '.'
        require_relative 'haml_parser_service'
      end

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
            code: example[:code],
            file_path: found_file
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
