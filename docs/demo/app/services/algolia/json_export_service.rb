# frozen_string_literal: true

require 'json'
require 'fileutils'

module Algolia
  # Service for exporting Algolia records to JSON files
  #
  # This service handles saving processed records to JSON files in the specified
  # location, creating directories as needed.
  #
  # @loco_example Export records to a file
  #   records = [...]
  #   service = Algolia::JsonExportService.new
  #   service.export(records, 'output_file.json')
  #
  class JsonExportService
    # Initialize the service
    #
    def initialize
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

        Rails.logger.debug "Data exported to #{output_path}"
        true
      rescue => e
        Rails.logger.debug "Error exporting to JSON: #{e.message}"
        Rails.logger.debug e.backtrace.inspect
        false
      end
    end
  end
end
