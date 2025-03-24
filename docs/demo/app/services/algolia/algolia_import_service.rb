# frozen_string_literal: true

require 'json'
require 'fileutils'

module Algolia
  # Service to handle importing data into Algolia
  #
  # This service provides a unified interface to process parsed HAML data
  # and send it to Algolia if credentials are available.
  #
  # @example Parse and handle a HAML file
  #   service = Algolia::AlgoliaImportService.new
  #   result = Algolia::HamlParserService.new(file_path).parse
  #   records = service.convert_to_records(result, file_path)
  #   service.import(records, file_path)
  #
  class AlgoliaImportService
    attr_reader :debug

    # Initialize the service
    #
    # @param [Boolean] debug Whether to output debug information
    #
    def initialize(debug: false)
      @debug = debug
    end

    # Check if Algolia is configured
    #
    # @return [Boolean] Whether Algolia credentials are available
    #
    def algolia_configured?
      app_id = ENV['ALGOLIA_APPLICATION_ID']
      api_key = ENV['ALGOLIA_API_KEY']

      if debug
        puts "ALGOLIA_APPLICATION_ID: #{app_id ? 'Present' : 'Missing'}"
        puts "ALGOLIA_API_KEY: #{api_key ? 'Present' : 'Missing'}"
      end

      !app_id.blank? && !api_key.blank?
    end

    # Import records into Algolia
    #
    # @param records [Array<Hash>] The records to import
    # @param source_file [String] The source file that was parsed
    #
    # @return [Boolean] Whether the operation was successful
    #
    def import(records, source_file, index_name = Algolia::Index::DEFAULT_INDEX)
      return true if records.empty?
      return false unless algolia_configured?

      puts "Sending data to Algolia..." if debug

      begin
        # Use our existing Index class
        index = Algolia::Index.new(index_name)

        # Add the examples to the index
        response = index.save_objects(records)

        puts "Successfully indexed #{records.length} examples to Algolia (index: #{index_name})" if debug
        true
      rescue => e
        puts "Error sending to Algolia: #{e.message}" if debug
        puts e.backtrace if debug
        false
      end
    end

    # Clear all records from the Algolia index
    #
    # @param index_name [String] Name of the index to clear (short name without prefix)
    # @return [Boolean] Whether the clear operation was successful
    #
    def clear_index(index_name = Algolia::Index::DEFAULT_INDEX)
      return false unless algolia_configured?

      puts "Clearing Algolia index #{index_name}" if debug

      begin
        # Use our existing Index class
        index = Algolia::Index.new(index_name)
        response = index.clear_objects

        puts "Index cleared successfully. Response: #{response}" if debug
        true
      rescue => e
        puts "Error clearing Algolia index: #{e.message}" if debug
        puts e.backtrace.join("\n") if debug
        false
      end
    end
  end
end
