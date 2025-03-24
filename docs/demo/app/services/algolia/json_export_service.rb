# frozen_string_literal: true

require 'json'
require 'fileutils'

module Algolia
  # Service for exporting Algolia records to JSON files
  #
  # This service handles saving processed records to JSON files in the specified
  # location, creating directories as needed.
  #
  # @example Export records to a file
  #   records = [...]
  #   service = Algolia::JsonExportService.new(debug: true)
  #   service.export(records, 'output_file.json')
  #
  class JsonExportService
    attr_reader :debug

    # Initialize the service
    #
    # @param debug [Boolean] Whether to output debug information
    #
    def initialize(debug: false)
      @debug = debug
    end

    # Export records to a JSON file
    #
    # @param records [Array<Hash>] The records to export
    # @param output_path [String] The output file path
    # @return [Boolean] Whether the operation was successful
    #
    def export(records, output_path)
      return false if records.nil? || output_path.nil? || output_path.empty?

      begin
        # Ensure the directory exists
        directory = File.dirname(output_path)
        FileUtils.mkdir_p(directory) unless File.directory?(directory)
        
        # Write the records to the file
        File.open(output_path, 'w') do |file|
          file.write(JSON.pretty_generate(records))
        end
        
        puts "Data exported to #{output_path}" if debug
        true
      rescue => e
        puts "Error exporting to JSON: #{e.message}" if debug
        puts e.backtrace if debug
        false
      end
    end
  end
end
