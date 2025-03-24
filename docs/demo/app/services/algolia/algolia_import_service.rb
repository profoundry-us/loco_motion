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
    # Initialize the service
    #
    def initialize
    end

    # Check if Algolia is configured
    #
    # @return [Boolean] Whether Algolia credentials are available
    #
    def algolia_configured?
      app_id = ENV['ALGOLIA_APPLICATION_ID']
      api_key = ENV['ALGOLIA_API_KEY']

      Rails.logger.debug "ALGOLIA_APPLICATION_ID: #{app_id ? 'Present' : 'Missing'}"
      Rails.logger.debug "ALGOLIA_API_KEY: #{api_key ? 'Present' : 'Missing'}"

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

      Rails.logger.debug "Sending #{records.length} records to Algolia..."

      begin
        # Use our existing Index class
        index = Algolia::Index.new(index_name)

        # Add the examples to the index
        response = index.save_objects(records)

        Rails.logger.debug "Successfully indexed #{records.length} examples to Algolia (index: #{index_name})"
        true
      rescue => e
        Rails.logger.debug "Error sending to Algolia: #{e.message}"
        Rails.logger.debug e.backtrace.inspect
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

      Rails.logger.debug "Clearing Algolia index #{index_name}"

      begin
        # Use our existing Index class
        index = Algolia::Index.new(index_name)
        response = index.clear_objects

        Rails.logger.debug "Index cleared successfully. Response: #{response}"
        true
      rescue => e
        Rails.logger.debug "Error clearing Algolia index: #{e.message}"
        Rails.logger.debug e.backtrace.join("\n")
        false
      end
    end
  end
end
