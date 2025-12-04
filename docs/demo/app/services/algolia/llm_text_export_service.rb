# frozen_string_literal: true

require 'fileutils'

module Algolia
  # Service for exporting component data to LLM.txt format
  #
  # This service formats aggregated component data into a plain text file
  # optimized for LLM consumption, with a top-level index and detailed
  # per-component sections.
  #
  # @loco_example Export components to LLM.txt
  #   components = Algolia::LLMAggregationService.new.aggregate_all
  #   service = Algolia::LLMTextExportService.new
  #   service.export_index(components, 'docs/llms.txt')
  #   service.export_full(components, 'docs/llms-full.txt')
  #
  class LlmTextExportService
    # Initialize the service
    #
    def initialize(aggregation_service = nil)
      @aggregation_service = aggregation_service || Algolia::LlmAggregationService.new
    end

    # Export components to an llms.txt index file
    #
    # @param components [Array<Hash>] Array of component data bundles
    # @param output_path [String] The output file path
    #
    # @return [Boolean] Whether the export was successful
    #
    def export_index(components, output_path)
      return false if components.nil? || components.empty? || output_path.nil? || output_path.empty?

      begin
        # Ensure the directory exists
        directory = File.dirname(output_path)
        FileUtils.mkdir_p(directory) unless File.directory?(directory)

        # Write the llms.txt file
        File.open(output_path, 'w:UTF-8') do |file|
          write_index_header(file)
          write_component_index(file, components)
        end

        Rails.logger.debug "llms.txt exported to #{output_path}"
        true
      rescue => e
        Rails.logger.debug "Error exporting llms.txt: #{e.message}"
        Rails.logger.debug e.backtrace.inspect
        false
      end
    end

    # Export components to an llms-full.txt file
    #
    # @param components [Array<Hash>] Array of component data bundles
    # @param output_path [String] The output file path
    #
    # @return [Boolean] Whether the export was successful
    #
    def export_full(components, output_path)
      return false if components.nil? || components.empty? || output_path.nil? || output_path.empty?

      begin
        # Ensure the directory exists
        directory = File.dirname(output_path)
        FileUtils.mkdir_p(directory) unless File.directory?(directory)

        # Write the llms-full.txt file
        File.open(output_path, 'w:UTF-8') do |file|
          write_full_header(file)
          write_component_details(file, components)
        end

        Rails.logger.debug "llms-full.txt exported to #{output_path}"
        true
      rescue => e
        Rails.logger.debug "Error exporting llms-full.txt: #{e.message}"
        Rails.logger.debug e.backtrace.inspect
        false
      end
    end

    # Deprecated: Use export_full instead
    def export(components, output_path)
      export_full(components, output_path)
    end

    private

    # Write the index file header
    #
    # @param file [File] The output file
    #
    def write_index_header(file)
      file.puts "# LocoMotion Documentation Index"
      file.puts ""
      file.puts "This file contains a list of available components in the LocoMotion library."
      file.puts "For full documentation, please refer to llms-full.txt"
      file.puts ""
    end

    # Write the full file header
    #
    # @param file [File] The output file
    #
    def write_full_header(file)
      library_metadata = @aggregation_service.extract_library_metadata

      file.puts "# LocoMotion Component Library v#{LocoMotion::VERSION}"
      file.puts ""
      file.puts "## Library Metadata"
      file.puts "- Framework: #{library_metadata[:framework]}"
      file.puts "- UI Library: #{library_metadata[:ui_library]}"
      file.puts "- Total Components: #{library_metadata[:total_components]}"
      file.puts "- Component Categories: #{library_metadata[:component_categories].join(', ')}"
      file.puts "- Helper Methods: #{library_metadata[:helper_prefixes].join(', ')} prefixes"
      file.puts "- File Conventions: Components in #{library_metadata[:file_conventions][:components]}, Examples in #{library_metadata[:file_conventions][:examples]}"
      file.puts ""
      file.puts "This file provides comprehensive documentation for all LocoMotion components."
      file.puts "LocoMotion is a Ruby on Rails component library built on ViewComponent and DaisyUI."
      file.puts ""
    end

    # Deprecated: Use write_full_header instead
    def write_header(file)
      write_full_header(file)
    end

    # Write the component index section
    #
    # @param file [File] The output file
    # @param components [Array<Hash>] Array of component data bundles
    #
    def write_component_index(file, components)
      file.puts "## Available Components"
      file.puts ""

      components.each do |component|
        section_text = component[:section].present? ? component[:section] : component[:framework]
        short_desc = truncate_description(component[:description], 80)

        file.puts "- **#{component[:component]}** (#{section_text}): #{short_desc}"
        file.puts "  API: #{component[:api_url]}"
        file.puts "  Examples: #{component[:examples_url]}"
        file.puts ""
      end
    end

    # Write the separator between index and details
    #
    # @param file [File] The output file
    #
    def write_separator(file)
      file.puts "---"
      file.puts ""
      file.puts "## Component Details"
      file.puts ""
    end

    # Write detailed component sections
    #
    # @param file [File] The output file
    # @param components [Array<Hash>] Array of component data bundles
    #
    def write_component_details(file, components)
      # Add usage patterns section
      write_usage_patterns_section(file)

      # Add categorized component index
      write_categorized_index(file, components)

      # Add separator and component details
      write_separator(file)

      components.each do |component|
        write_component_section(file, component)
      end
    end

    # Write a single component section
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_component_section(file, component)
      file.puts "=== Component: #{component[:component]}"
      file.puts "Group: #{component[:section].present? ? component[:section] : component[:framework]}"
      file.puts "Title: #{component[:title]}" if component[:title].present?
      file.puts "API URL: #{component[:api_url]}"
      file.puts "Examples URL: #{component[:examples_url]}"
      file.puts "File: #{component[:file_path]}"
      file.puts ""

      if component[:description].present?
        file.puts "Description:"
        file.puts component[:description]
        file.puts ""
      end

      # Enhanced metadata sections
      write_api_signature_section(file, component)
      write_related_components_section(file, component)
      write_rails_integration_section(file, component)
      write_helpers_section(file, component)
      write_examples_section(file, component)

      file.puts "---"
      file.puts ""
    end

    # Write the helpers section for a component
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_helpers_section(file, component)
      file.puts "Helpers:"

      # Get helper names from the component registry
      metadata = LocoMotion::COMPONENTS[component[:component]]
      if metadata && metadata[:names]
        helper_names = [metadata[:names]].flatten.compact
        framework_prefix = component[:framework].underscore

        helper_names.each do |name|
          file.puts "- #{framework_prefix}_#{name}"
        end
      else
        file.puts "- (No helper methods defined)"
      end

      file.puts ""
    end

    # Write the examples section for a component
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_examples_section(file, component)
      return unless component[:examples].present? && component[:examples].any?

      file.puts "Examples:"
      file.puts ""

      component[:examples].each do |example|
        next unless example[:title].present?

        file.puts "-- Example: #{example[:title]}"

        if example[:description].present?
          file.puts "Description:"
          file.puts example[:description]
          file.puts ""
        end

        if example[:code].present?
          # Strip the description block from the code since we already show it above
          cleaned_code = strip_description_block(example[:code])

          file.puts "Code (HAML):"
          file.puts "```haml"
          file.puts cleaned_code
          file.puts "```"
          file.puts ""
        end

        file.puts "URL: #{component[:examples_url]}##{example[:anchor]}"
        file.puts ""
      end
    end

    # Strip the description block from HAML code
    #
    # @param code [String] The HAML code
    #
    # @return [String] Code with description block removed
    #
    def strip_description_block(code)
      return code if code.nil? || code.empty?

      lines = code.split("\n")
      result = []
      in_description = false

      lines.each do |line|
        # Detect the start of a description block
        if line.match?(/^\s*-\s+doc\.with_description\s+do\s*$/)
          in_description = true
          next
        end

        # If we're in a description block, skip until we find actual HAML code
        if in_description
          # Empty lines are part of the description
          if line.strip.empty?
            next
          end

          # Check if this line looks like HAML code (starts with =, -, %, ., or #)
          # We need to check at the indentation level of the doc_example block (typically 2 spaces)
          if line.match?(/^\s{0,2}[=\-%#\.]/)
            # This is actual HAML code, exit description mode
            in_description = false
            # Don't skip this line - it's actual code
          else
            # This is still description text, skip it
            next
          end
        end

        result << line
      end

      result.join("\n").strip
    end

    # Truncate a description to a maximum length
    #
    # @param text [String] The text to truncate
    # @param max_length [Integer] Maximum length
    #
    # @return [String] Truncated text
    #
    def truncate_description(text, max_length)
      return "" if text.nil? || text.empty?

      if text.length > max_length
        "#{text[0...max_length].strip}..."
      else
        text
      end
    end

    # Write the API signature section for a component
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_api_signature_section(file, component)
      return unless component[:api_signature].present?

      file.puts "API Signature:"

      if component[:api_signature][:helper_methods].present?
        component[:api_signature][:helper_methods].each do |method|
          file.puts "- #{method}"
        end
      end

      if component[:api_signature][:initialize_signature].present?
        file.puts ""
        file.puts "Initialize Method:"
        file.puts "  #{component[:api_signature][:initialize_signature]}"
      end

      if component[:api_signature][:common_parameters].present?
        file.puts ""
        file.puts "Common Parameters:"
        component[:api_signature][:common_parameters].each do |param|
          file.puts "- #{param[:name]} (#{param[:type]}): #{param[:description]}"
        end
      end

      file.puts ""
    end

    # Write the related components section for a component
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_related_components_section(file, component)
      return unless component[:related_components].present? && component[:related_components].any?

      file.puts "Related Components:"
      component[:related_components].each do |related|
        file.puts "- #{related}"
      end
      file.puts ""
    end

    # Write the Rails integration section for a component
    #
    # @param file [File] The output file
    # @param component [Hash] Component data bundle
    #
    def write_rails_integration_section(file, component)
      return unless component[:rails_integration].present?

      file.puts "Rails Integration:"

      if component[:rails_integration][:base_class].present?
        file.puts "- Base Class: #{component[:rails_integration][:base_class]}"
      end

      if component[:rails_integration][:view_component]
        file.puts "- ViewComponent: Yes"
      end

      if component[:rails_integration][:includes].present? && component[:rails_integration][:includes].any?
        file.puts "- Includes: #{component[:rails_integration][:includes].join(', ')}"
      end

      file.puts ""
    end

    # Write the usage patterns section
    #
    # @param file [File] The output file
    #
    def write_usage_patterns_section(file)
      patterns_file = Rails.root.join('docs', 'demo', 'data', 'usage_patterns.md')

      if File.exist?(patterns_file)
        file.puts "## Common Usage Patterns"
        file.puts ""

        File.read(patterns_file).each_line do |line|
          # Skip the markdown header since we already have one
          next if line.start_with?('# LocoMotion Usage Patterns')
          file.puts line
        end

        file.puts ""
      end
    end

    # Write the categorized component index
    #
    # @param file [File] The output file
    # @param components [Array<Hash>] Array of component data bundles
    #
    def write_categorized_index(file, components)
      file.puts "## Components by Category"
      file.puts ""

      # Group components by category
      categories = {}
      components.each do |component|
        category = component[:section].present? ? component[:section] : component[:framework]
        categories[category] ||= []
        categories[category] << component
      end

      # Write each category
      categories.sort.each do |category, category_components|
        file.puts "### #{category}"
        file.puts ""

        category_components.each do |component|
          short_desc = truncate_description(component[:description], 80)
          file.puts "- **#{component[:component]}**: #{short_desc}"
        end

        file.puts ""
      end
    end
  end
end
