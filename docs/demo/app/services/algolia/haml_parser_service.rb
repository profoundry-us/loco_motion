# frozen_string_literal: true

require 'haml'

module Algolia
  # Service for parsing HAML files using the HAML library
  #
  # This service extracts documentation, examples, and their metadata from HAML
  # files to be used for indexing in Algolia.
  #
  # @loco_example Parse a HAML file
  #   parser = Algolia::HamlParserService.new(file_path)
  #   result = parser.parse
  #
  class HamlParserService
    attr_reader :ast, :result

    # Initialize the HAML parser service with a file path
    #
    # @param file_path [String] Path to the HAML file to parse
    #
    def initialize(file_path)
      Rails.logger.debug "[DEBUG] initialize"
      @file_path = file_path
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
    # @return [Hash] Extracted documentation with structure {:title, :description, :examples}
    #
    def parse
      Rails.logger.debug "[DEBUG] parse"

      begin
        read_file
        generate_ast
        process_ast
      rescue => e
        Rails.logger.debug "Error rendering HAML: #{e.message}"
        Rails.logger.debug e.backtrace.join("\n")
      end

      Rails.logger.debug "[DEBUG] parse result: #{@result}"

      return @result
    end

    # Read the file content
    #
    # @return [String, nil] File content or nil if file doesn't exist
    # @raise [RuntimeError] If file does not exist
    #
    def read_file
      Rails.logger.debug "[DEBUG]   read_file"
      raise "File does not exist: #{@file_path}" unless File.exist?(@file_path)

      @content = File.read(@file_path)
    end

    # Generate Abstract Syntax Tree from HAML content
    #
    # @return [Haml::Parser::ParseNode] The AST root node
    #
    def generate_ast
      Rails.logger.debug "[DEBUG]   generate_ast"
      @ast = @parser.call(@content)
    end

    # Process the AST and extract documentation
    #
    # @return [void]
    #
    def process_ast
      Rails.logger.debug "[DEBUG]   process_ast"
      @ast.children.each do |child|
        process_child(child)
      end
    end

    # Process an individual AST node
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [void]
    #
    def process_child(node)
      Rails.logger.debug "[DEBUG]     process_child (#{node.type})"
      process_doc_title_and_description(node) if @result[:title].blank?
      process_example(node)
    end

    # Process a node to extract title and description
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [void]
    #
    def process_doc_title_and_description(node)
      Rails.logger.debug "[DEBUG]       process_doc_title_and_description (#{node.type})"
      # If we are a doc_title node, set the title / description and move on
      if is_doc_title?(node)
        @result[:title] = extract_title(node)

        node.children.each do |child|
          @result[:description] = extract_description(child)
        end
      else
        # Otherwise, iterate over our children and try to find a doc_title node
        (node.children || []).each do |child|
          process_doc_title_and_description(child)
        end
      end
    end

    # Process a node to extract example information
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [void]
    #
    def process_example(node)
      Rails.logger.debug "[DEBUG]       process_example (#{node.type})"
      # Skip doc_title nodes
      return if is_doc_title?(node)

      # Grab the example title and description
      title = process_example_title(node)
      description = process_example_description(node)
      code = process_example_code(node)

      # Add the values as an example
      @result[:examples] << {
        type: 'example',
        title: clean_string((title || "").strip),
        anchor: clean_string((title || "").parameterize.strip),
        description: clean_string((description || "").strip),
        code: (code || "").strip
      }
    end

    # Extract the title from an example node
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [String, nil] The extracted title or nil
    #
    def process_example_title(node)
      Rails.logger.debug "[DEBUG]         process_example_title (#{node.type})"
      return extract_title(node) if is_example_title?(node)

      (node.children || []).map do |child|
        process_example_title(child)
      end.join(" ")
    end

    # Extract the description from an example node
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [String] The extracted description
    #
    def process_example_description(node)
      Rails.logger.debug "[DEBUG]         process_example_description (#{node.type})"
      if is_example_description?(node)
        (node.children || []).map do |child|
          extract_description(child)
        end.join(" ")
      else
        (node.children || []).map do |child|
          process_example_description(child)
        end.join(" ")
      end
    end

    # Extract the code from an example node
    #
    # @param node [Haml::Parser::ParseNode] The node to process
    # @return [String, nil] The extracted code or nil
    #
    def process_example_code(node)
      Rails.logger.debug "[DEBUG]         process_example_code (#{node.type})"
      # Skip example description nodes
      return if is_example_description?(node)

      extract_code(node)
    end

    # Extract title from a node
    #
    # @param node [Haml::Parser::ParseNode] The node to extract title from
    # @return [String] The extracted title
    #
    def extract_title(node)
      Rails.logger.debug "[DEBUG]           extract_title (#{node.type})"
      clean_title(node.value[:text])
    end

    # Extract description from a node
    #
    # @param node [Haml::Parser::ParseNode] The node to extract description from
    # @return [String] The extracted description
    #
    def extract_description(node)
      Rails.logger.debug "[DEBUG]           extract_description (#{node.type})"
      my_desc = clean_string(is_tag_node?(node) ? node.value[:value] : node.value[:text])
      my_desc = "" if my_desc.nil?

      my_desc + " " + (node.children || []).map do |child|
        extract_description(child)
      end.join(" ")
    end

    # Extract code from a node
    #
    # @param node [Haml::Parser::ParseNode] The node to extract code from
    # @param level [Integer] The indentation level
    # @return [String] The extracted code
    #
    def extract_code(node, level = 0)
      Rails.logger.debug "[DEBUG]           extract_code (#{node.type})"
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

    # Generate HAML code from a tag node
    #
    # @param node [Haml::Parser::ParseNode] The tag node
    # @param level [Integer] The indentation level
    # @return [String] The generated HAML code
    #
    def generate_code_from_tag(node, level = 0)
      Rails.logger.debug "[DEBUG]             generate_code_from_tag (#{node.type})"
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

    #
    # Returns as hash version of the AST without the `parent` attributes.
    # Useful for debugging.
    #
    # @param ast [Haml::Parser::ParseNode] The AST to convert
    # @return [Hash] The AST as a hash
    #
    def ast_hash(ast = @ast)
      h = ast.to_h.except(:parent)

      h[:children] = (h[:children] || []).map do |child|
        ast_hash(child)
      end

      h
    end

    private

    # Check if a node is a doc_title node
    #
    # @param node [Haml::Parser::ParseNode] The node to check
    # @return [Boolean] Whether the node is a doc_title node
    #
    def is_doc_title?(node)
      node.type == :script && node.value[:text].include?("doc_title")
    end

    # Check if a node is an example_title node
    #
    # @param node [Haml::Parser::ParseNode] The node to check
    # @return [Boolean] Whether the node is an example_title node
    #
    def is_example_title?(node)
      node.type == :script && node.value[:text].include?("doc_example")
    end

    # Check if a node is an example_description node
    #
    # @param node [Haml::Parser::ParseNode] The node to check
    # @return [Boolean] Whether the node is an example_description node
    #
    def is_example_description?(node)
      node.type == :silent_script && node.value[:text].include?("doc.with_description")
    end

    # Check if a node is a tag node
    #
    # @param node [Haml::Parser::ParseNode] The node to check
    # @return [Boolean] Whether the node is a tag node
    #
    def is_tag_node?(node)
      node.type == :tag
    end

    # Clean a title string
    #
    # @param title [String] The title to clean
    # @return [String] The cleaned title
    #
    def clean_title(str)
      Rails.logger.debug "[DEBUG]             clean_title"
      return str if str.blank?

      match = str.match(/title:\s*"([^"]+)"/)

      match ? match[1].strip : str.strip
    end

    # Clean a string by removing excessive whitespace and HAML artifacts
    #
    # @param str [String] The string to clean
    # @return [String] The cleaned string
    #
    def clean_string(str)
      Rails.logger.debug "[DEBUG]             clean_string"
      return "" if str.nil?

      # Basic whitespace cleanup
      cleaned = str.gsub(/\s+/, " ").strip

      # Remove common HAML/Ruby artifacts that cause issues
      cleaned = cleaned.gsub("succeed", "")
      cleaned = cleaned.gsub('"" do', "")
      cleaned = cleaned.gsub('" do', "")
      cleaned = cleaned.gsub("end", "")
      cleaned = cleaned.gsub("daisy_link", "link to")
      cleaned = cleaned.gsub("hero_icon", "icon")
      cleaned = cleaned.gsub(/right_icon="[^"]*"/, "")
      cleaned = cleaned.gsub(/right_icon_css="[^"]*"/, "")
      cleaned = cleaned.gsub(/target="[^"]*"/, "")
      cleaned = cleaned.gsub(/css="[^"]*"/, "")
      cleaned = cleaned.gsub(/size-\d+/, "")
      cleaned = cleaned.gsub("arrow-top-right-on-square", "")
      cleaned = cleaned.gsub("doc_note", "")
      cleaned = cleaned.gsub(/\(modifier: *:[^)]+\)/, "")
      cleaned = cleaned.gsub(/\(css: *"[^"]*"\)/, "")

      # Clean up any remaining odd spacing
      cleaned = cleaned.gsub("  ", " ").strip
      cleaned = cleaned.gsub(" .", ".").strip
      cleaned = cleaned.gsub(" ,", ",").strip

      cleaned
    end
  end
end
