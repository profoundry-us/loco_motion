# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module LocoMotion
  module Algolia
    # Extracts YARD documentation from component files to enhance the search index.
    class DocumentationExtractor
      # Initialize a new documentation extractor
      #
      # @param root_path [String] The root path of the project (defaults to current directory)
      def initialize(root_path = '.')
        @root_path = root_path
      end

      # Attempt to extract documentation for a component
      #
      # @param component_name [String] The fully qualified component name
      # @return [Hash, nil] The extracted documentation or nil if not found
      def extract_documentation(component_name)
        # Convert the component name to a file path
        file_path = component_name_to_file_path(component_name)
        
        # If the file doesn't exist, return nil
        return nil unless File.exist?(file_path)
        
        # Read the file and extract documentation
        parse_documentation(File.read(file_path), component_name)
      end

      private

      # Convert a component name to a file path
      #
      # @param component_name [String] The fully qualified component name (e.g., Daisy::Actions::ButtonComponent)
      # @return [String] The file path
      def component_name_to_file_path(component_name)
        parts = component_name.split('::')
        framework = parts.first.underscore
        path_parts = parts[1..-1].map(&:underscore)
        file_name = "#{path_parts.last}.rb"
        path_parts = path_parts[0..-2] if path_parts.size > 1
        
        # Try different possible locations
        possible_paths = [
          File.join(@root_path, 'app', 'components', framework, *path_parts, file_name),
          File.join(@root_path, 'lib', framework, 'components', *path_parts, file_name)
        ]
        
        possible_paths.find { |path| File.exist?(path) } || possible_paths.first
      end

      # Parse documentation from file content
      #
      # @param content [String] The file content
      # @param component_name [String] The component name
      # @return [Hash] Extracted documentation
      def parse_documentation(content, component_name)
        # Simple regex-based extraction
        description = extract_description(content)
        parts = extract_parts(content)
        slots = extract_slots(content)
        examples = extract_examples(content)
        
        {
          description: description,
          parts: parts,
          slots: slots,
          examples: examples,
          searchable_text: [
            description,
            parts.map { |p| "Part: #{p[:name]} - #{p[:description]}" }.join(" "),
            slots.map { |s| "Slot: #{s[:name]} - #{s[:description]}" }.join(" "),
            examples.map { |e| e[:code] }.join(" ")
          ].join(" ")
        }
      end

      # Extract the main description from content
      #
      # @param content [String] The file content
      # @return [String] The extracted description
      def extract_description(content)
        # Look for class-level YARD doc
        if content =~ /# (.+?)\n\s*class/m
          desc = $1.strip
          # Remove YARD tags
          desc.gsub!(/@\w+.*$/, '')
          return desc.split("\n").map(&:strip).join(" ")
        end
        
        ''
      end

      # Extract parts from content
      #
      # @param content [String] The file content
      # @return [Array<Hash>] The extracted parts
      def extract_parts(content)
        parts = []
        
        # Match define_part or define_parts calls
        content.scan(/define_part(?:s)?\s+([^\n]+)/i) do |match|
          part_names = match[0].strip
          
          # Handle different formats
          if part_names =~ /:/  # Hash syntax
            part_names.scan(/(:\w+)/) do |part_match|
              part_name = part_match[0].sub(':', '')
              parts << { name: part_name, description: extract_part_description(content, part_name) }
            end
          else  # Array or symbol syntax
            part_names.scan(/:(\w+)/) do |part_match|
              part_name = part_match[0]
              parts << { name: part_name, description: extract_part_description(content, part_name) }
            end
          end
        end
        
        parts
      end

      # Extract description for a specific part
      #
      # @param content [String] The file content
      # @param part_name [String] The part name
      # @return [String] The part description
      def extract_part_description(content, part_name)
        if content =~ /@part #{part_name}\s+(.+?)(?=\n\s*@|\n\s*def|\n\s*$)/m
          $1.strip
        else
          ''
        end
      end

      # Extract slots from content
      #
      # @param content [String] The file content
      # @return [Array<Hash>] The extracted slots
      def extract_slots(content)
        slots = []
        
        # Match renders_one and renders_many calls
        content.scan(/renders_(one|many)\s+([^\n]+)/i) do |match|
          type = match[0]  # 'one' or 'many'
          slot_def = match[1].strip
          
          if slot_def =~ /:/  # Hash syntax
            slot_def.scan(/(:\w+)/) do |slot_match|
              slot_name = slot_match[0].sub(':', '')
              slots << { 
                name: slot_name, 
                multiple: (type == 'many'),
                description: extract_slot_description(content, slot_name) 
              }
            end
          end
        end
        
        slots
      end

      # Extract description for a specific slot
      #
      # @param content [String] The file content
      # @param slot_name [String] The slot name
      # @return [String] The slot description
      def extract_slot_description(content, slot_name)
        # Check for both @slot and @slot+ (for renders_many)
        if content =~ /@slot(?:\+)?\s+#{slot_name}\s+(.+?)(?=\n\s*@|\n\s*def|\n\s*$)/m
          $1.strip
        else
          ''
        end
      end

      # Extract examples from content
      #
      # @param content [String] The file content
      # @return [Array<Hash>] The extracted examples
      def extract_examples(content)
        examples = []
        
        # Match @loco_example blocks
        content.scan(/@loco_example(?:\s+(.+?))?\n(.+?)(?=(?:\n\s*@)|\z)/m) do |match|
          title = match[0]&.strip || ''
          code = match[1].strip
          examples << { title: title, code: code }
        end
        
        examples
      end
    end
  end
end
