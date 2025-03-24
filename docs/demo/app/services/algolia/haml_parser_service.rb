# frozen_string_literal: true

require 'haml'

module Algolia
  # Service for parsing HAML files using the HAML library
  class HamlParserService
    attr_reader :ast, :result

    # Initialize the HAML parser service with a file path
    #
    # @param file_path [String] Path to the HAML file to parse
    # @param debug [Boolean] Whether to output debug information
    def initialize(file_path, debug = false)
      puts "[DEBUG] initialize" if debug
      @file_path = file_path
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
      puts "[DEBUG] parse" if @debug

      begin
        read_file
        generate_ast
        process_ast
      rescue => e
        puts "Error rendering HAML: #{e.message}" if @debug
        puts e.backtrace.join("\n") if @debug
      end

      puts "[DEBUG] parse result: #{@result}"

      return @result
    end

    # Read the file content
    #
    # @return [String, nil] File content or nil if file doesn't exist
    def read_file
      puts "[DEBUG]   read_file" if @debug
      raise "File does not exist: #{@file_path}" unless File.exist?(@file_path)

      @content = File.read(@file_path)
    end

    def generate_ast
      puts "[DEBUG]   generate_ast" if @debug
      @ast = @parser.call(@content)
    end

    def process_ast
      puts "[DEBUG]   process_ast" if @debug
      @ast.children.each do |child|
        process_child(child)
      end
    end

    def process_child(node)
      puts "[DEBUG]     process_child (#{node.type})" if @debug
      process_doc_title_and_description(node) if @result[:title].blank?
      process_example(node)
    end

    def process_doc_title_and_description(node)
      puts "[DEBUG]       process_doc_title_and_description (#{node.type})" if @debug
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

    def process_example(node)
      puts "[DEBUG]       process_example (#{node.type})" if @debug
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

    def process_example_title(node)
      puts "[DEBUG]         process_example_title (#{node.type})" if @debug
      return extract_title(node) if is_example_title?(node)

      (node.children || []).map do |child|
        process_example_title(child)
      end.join(" ")
    end

    def process_example_description(node)
      puts "[DEBUG]         process_example_description (#{node.type})" if @debug
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

    def process_example_code(node)
      puts "[DEBUG]         process_example_code (#{node.type})" if @debug
      # Skip example description nodes
      return if is_example_description?(node)

      extract_code(node)
    end

    def extract_title(node)
      puts "[DEBUG]           extract_title (#{node.type})" if @debug
      clean_title(node.value[:text])
    end

    def extract_description(node)
      puts "[DEBUG]           extract_description (#{node.type})" if @debug
      my_desc = clean_string(is_tag_node?(node) ? node.value[:value] : node.value[:text])
      my_desc = "" if my_desc.nil?

      my_desc + " " + (node.children || []).map do |child|
        extract_description(child)
      end.join(" ")
    end

    #
    # Extracts the code from a node.
    #
    def extract_code(node, level = 0)
      puts "[DEBUG]           extract_code (#{node.type})" if @debug
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
    # Since we only have an AST here, attempt to re-generate the code for
    # basic tags. This may not be perfect but should be close enough for
    # search purposes.
    #
    def generate_code_from_tag(node, level = 0)
      puts "[DEBUG]             generate_code_from_tag (#{node.type})" if @debug
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

    def is_doc_title?(node)
      node.type == :script && node.value[:text].include?("doc_title")
    end

    def is_example_title?(node)
      node.type == :script && node.value[:text].include?("doc_example")
    end

    def is_example_description?(node)
      node.type == :silent_script && node.value[:text].include?("doc.with_description")
    end

    def is_tag_node?(node)
      node.type == :tag
    end

    def is_markdown_node?(node)
      node.type == :filter && node.value[:name] == "markdown"
    end

    #
    # Attempts to grab just the title out of a string
    #
    def clean_title(str)
      puts "[DEBUG]             clean_title" if @debug
      return str if str.blank?

      match = str.match(/title:\s*"([^"]+)"/)

      match ? match[1].strip : str.strip
    end

    #
    # Cleans up a string for display in the search.
    #
    def clean_string(str)
      puts "[DEBUG]             clean_string" if @debug
      return "" if str.nil?
      str.gsub(/\s+/, " ").strip
    end

    def ast_hash(ast = @ast)
      h = ast.to_h.except(:parent)

      h[:children] = (h[:children] || []).map do |child|
        ast_hash(child)
      end

      h
    end
  end
end
