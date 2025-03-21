# frozen_string_literal: true

require 'haml'

module LocoMotion
  module Algolia
    # Service for parsing HAML files using the HAML library
    class HamlParserService
      attr_reader :ast, :result

      # Initialize the HAML parser service with a file path
      #
      # @param file_path [String] Path to the HAML file to parse
      def initialize(file_path, debug = false)
        @file_path = file_path
        @content = read_file
        @debug = debug
        @parser = Haml::Parser.new({})
        @ast = nil
        @result = {
          title: "",
          description: "",
          examples: []
        }
      end

      # Parse the HAML file to extract documentation
      #
      # @return [Hash] Extracted documentation
      def parse
        return {} unless @content

        begin
          generate_ast
          process_ast
        rescue => e
          puts "Error rendering HAML: #{e.message}" if @debug
          puts e.backtrace.join("\n") if @debug
        end

        return @result
      end

      # Read the file content
      #
      # @return [String, nil] File content or nil if file doesn't exist
      def read_file
        return nil unless File.exist?(@file_path)

        File.read(@file_path)
      end

      def generate_ast
        @ast = @parser.call(@content)
      end

      def process_ast
        @ast.children.each do |child|
          puts "\n\n *** extracting child: #{child.value[:text]}" if @debug
          extract_title_and_description(child) if child.value[:text].include? "doc_title"
          extract_example(child) if child.value[:text].include? "doc_example"
        end
      end

      def ast_hash(ast = @ast)
        h = ast.to_h.except(:parent)

        h[:children] = (h[:children] || []).map do |child|
          ast_hash(child)
        end

        h
      end

      def extract_title_and_description(node)
        @result[:title] = clean_title(node.value[:text])
        @result[:description] = clean_string(extract_description(node.children.first))
      end

      def extract_example(node)
        # Some examples may have only the code and no description
        if is_description_node?(node)
          description_node = node.children.first
          code_nodes = node.children[1..-1]
        else
          description_node = nil
          code_nodes = node.children
        end

        # Extract the description using the appropriate node
        description = description_node ? clean_string(extract_description(description_node)) : ''

        # Add the values as an example
        @result[:examples] << {
          title: clean_title(node.value[:text]),
          description: description,
          code: code_nodes.map { |child| extract_code(child) }.join("\n").strip
        }
      end

      def extract_description(node)
        # Make sure we don't break on nil nodes
        return "" if node.nil?

        # Check if this is a Markdown node
        is_markdown = (node.type == :filter && node.value[:name] == "markdown")

        puts "  *** desc node: #{node.type} (#{is_markdown}) - #{node.value}" if @debug

        # Initialize the description to the text or a blank string
        desc = ""
        desc = node.value[:text] if (node.type == :plain || is_markdown)

        # Grab the text from any children too
        child_descs = node.children.map do |child|
          extract_description(child)
        end

        # Return the description + the child descriptions
        desc + child_descs.join("\n")
      end

      #
      # Extracts the code from a node.
      #
      def extract_code(node, level = 0)
        puts "\n  *** code node (#{level}): #{node.type} - #{node.value}" if @debug

        # Make sure we add proper HAML indentation
        code = "  " * level

        code += "-" if node.type == :silent_script
        code += "=" if node.type == :script

        # Add the node's text if it has any
        code += node.value[:text] if node.value.has_key?(:text)

        # Add generated code if it is a tag node
        code += generate_code_from_tag(node, level) if node.type == :tag

        # Add all children and return
        code + "\n" + node.children.map do |child|
          extract_code(child, level + 1)
        end.join("\n")
      end

      #
      # Checks if a node or its first child contains a description block
      #
      def is_description_node?(node)
        return false unless node && node.children && node.children.any?

        # Check if the first child is a silent script node with 'doc.with_description'
        first_child = node.children.first
        return false unless first_child.type == :silent_script

        # Check if the script includes a call to 'with_description'
        first_child.value[:text].include?("with_description")
      end

      #
      # Attempts to grab just the title out of a string
      #
      def clean_title(str)
        match = str.match(/title:\s*"([^"]+)"/)

        match ? match[1] : str
      end

      #
      # Cleans up a string for display in the search.
      #
      def clean_string(str)
        str.gsub(/\s+/, " ").strip
      end

      #
      # Since we only have an AST here, attempt to re-generate the code for
      # basic tags. This may not be perfect but should be close enough for
      # search purposes.
      #
      def generate_code_from_tag(node, level = 0)
        # Initialize some variables
        code = ""
        indent = "  " * (level + 1)
        non_class_attrs = node.value[:attributes].except("class")

        # Add a '%' and the tag name unless it is a div
        code += "%#{node.value[:name]}" unless node.value[:name] == "div"

        # Render the standard HAML class syntax if classes are provided
        code += ".#{node.value[:attributes]["class"].split(" ").join(".")}" if node.value[:attributes] && node.value[:attributes]["class"]

        # Add any non-class attributes
        code += non_class_attrs.inspect if non_class_attrs.present?

        # Add any dynamic attributes (like data-controller)
        code += node.value[:dynamic_attributes].old.gsub("\n", "\n" + indent) if node.value[:dynamic_attributes]&.old.present?

        # Add a value if present (text inside the tag)
        code += (" " + node.value[:value]) if node.value[:value].present?

        # Return the generated code line
        code
      end
    end
  end
end
