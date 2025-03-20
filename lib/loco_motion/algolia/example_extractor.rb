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

        # Read the example file content
        content = File.read(found_file)

        # Parse the content to extract description and examples
        parse_example_file(content, found_file, framework, section, example_name)
      rescue => e
        # Log error for debugging
        puts "Error extracting examples: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        # Return empty result if there's an error
        { description: nil, examples: [] }
      end

      private

      # Parse the example file to extract doc_title and doc_example blocks
      #
      # @param content [String] The file content
      # @param file_path [String] The file path for reference
      # @param framework [String] The framework name
      # @param section [String] The section name
      # @param example_name [String] The example name
      # @return [Hash] Hash with description and examples array
      def parse_example_file(content, file_path, framework, section, example_name)
        result = { description: nil, examples: [] }

        # Extract the doc_title block and its content
        if content =~ /^\s*=\s*doc_title\s*\(.*?title:\s*["']?([^"',)]+)["']?.*?\)\s*do\s*\|.*?\|(.*?)(?:^\s*=|\z)/m
          page_title = $1
          description_content = $2.strip
          result[:description] = description_content
        end

        # Extract all doc_example blocks
        content.scan(/^(\s*)=\s*doc_example\s*\(.*?title:\s*["']?([^"',)]+)["']?.*?\)\s*do\s*\|doc\|(.*?)(?=^\s*=\s*doc_|\z)/m) do |indent, title, example_content|
          description = ""
          code = example_content.dup

          # Extract descriptions from doc.with_description block
          if example_content =~ /^(\s*)-\s*doc\.with_description\s*do(.*?)(?:^\1-\s*end)/m
            desc_block_indent = $1
            description_block = $2

            # Process the content based on what's inside the block
            description = extract_description_from_block(description_block)
          end

          result[:examples] << {
            title: "#{framework.capitalize} #{section&.capitalize} - #{title}",
            description: description,
            code: code,
            file_path: file_path
          }
        end

        # If no examples were found, use the whole file as one example
        if result[:examples].empty?
          result[:examples] << {
            title: "#{framework.capitalize} #{section&.capitalize} - #{example_name.titleize}",
            description: result[:description] || "",
            code: content,
            file_path: file_path
          }
        end

        result
      end

      # Extract the description text from a block, handling different HAML structures
      # @param block_content [String] The content inside the doc.with_description block
      # @return [String] The extracted description text
      def extract_description_from_block(block_content)
        description = ""

        # Extract markdown content
        markdown_blocks = []

        # First, try to get the direct markdown block (most common case)
        if block_content =~ /\s*:markdown\s*\n(.*?)(?=\s*=\s*doc_note|\s*-\s*end|\s*\.)/m
          markdown_content = $1.strip
          markdown_blocks << markdown_content unless markdown_content.empty?
        end

        # Then check for paragraphs
        if block_content =~ /\s*%p\s*(.*?)(?=\s*=\s*doc_note|\s*-\s*end|\s*\.)/m
          paragraph_content = $1.strip
          markdown_blocks << paragraph_content unless paragraph_content.empty?
        end

        # If we found any content, process it
        unless markdown_blocks.empty?
          # Clean up and join the markdown content
          clean_blocks = markdown_blocks.map do |block|
            # Process each line to strip whitespace and remove empty lines
            block.split("\n").map(&:strip).reject(&:empty?).join("\n")
          end

          description = clean_blocks.join("\n\n")
        end

        # If we still don't have a description, try a more flexible approach with line-by-line inspection
        if description.empty?
          lines = block_content.split("\n")
          content_lines = []
          in_markdown = false
          in_paragraph = false

          lines.each do |line|
            stripped_line = line.strip

            # Start of markdown block
            if stripped_line == ":markdown"
              in_markdown = true
              next
            # Start of paragraph
            elsif stripped_line.start_with?("%p")
              in_paragraph = true
              # Extract inline content if any
              paragraph_content = stripped_line.sub(/^%p\s*/, "").strip
              content_lines << paragraph_content unless paragraph_content.empty?
              next
            # Skip doc_note blocks
            elsif stripped_line.start_with?("=") && stripped_line.include?("doc_note")
              # Skip this and following lines until we hit something else
              next
            # End of blocks
            elsif stripped_line.start_with?("-") && stripped_line.include?("end")
              in_markdown = false
              in_paragraph = false
              next
            end

            # If we're in a content block and the line has content, add it
            if (in_markdown || in_paragraph) && !stripped_line.empty? && !stripped_line.start_with?("=", "-", ":", "%")
              content_lines << stripped_line
            end
          end

          description = content_lines.join("\n") unless content_lines.empty?
        end

        description
      end
    end
  end
end
