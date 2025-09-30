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
  #   service.export(components, 'docs/LLM.txt')
  #
  class LlmTextExportService
    # Initialize the service
    #
    def initialize
    end

    # Export components to an LLM.txt file
    #
    # @param components [Array<Hash>] Array of component data bundles
    # @param output_path [String] The output file path
    #
    # @return [Boolean] Whether the export was successful
    #
    def export(components, output_path)
      return false if components.nil? || components.empty? || output_path.nil? || output_path.empty?

      begin
        # Ensure the directory exists
        directory = File.dirname(output_path)
        FileUtils.mkdir_p(directory) unless File.directory?(directory)

        # Write the LLM.txt file
        File.open(output_path, 'w:UTF-8') do |file|
          write_header(file)
          write_component_index(file, components)
          write_separator(file)
          write_component_details(file, components)
        end

        Rails.logger.debug "LLM.txt exported to #{output_path}"
        true
      rescue => e
        Rails.logger.debug "Error exporting LLM.txt: #{e.message}"
        Rails.logger.debug e.backtrace.inspect
        false
      end
    end

    private

    # Write the file header
    #
    # @param file [File] The output file
    #
    def write_header(file)
      file.puts "# LocoMotion Component Library"
      file.puts ""
      file.puts "This file provides comprehensive documentation for all LocoMotion components."
      file.puts "LocoMotion is a Ruby on Rails component library built on ViewComponent and DaisyUI."
      file.puts ""
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
          file.puts "Code (HAML):"
          file.puts "```haml"
          file.puts example[:code]
          file.puts "```"
          file.puts ""
        end
        
        file.puts "URL: #{component[:examples_url]}##{example[:anchor]}"
        file.puts ""
      end
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
  end
end
