# frozen_string_literal: true

require 'json'
require 'fileutils'

module LocoMotion
  module Algolia
    # Service to handle importing data into Algolia or saving to a file
    #
    # This service provides a unified interface to process parsed HAML data,
    # either by sending it to Algolia if credentials are available or by
    # writing it to a JSON file in the tmp directory.
    #
    # @example Parse and handle a HAML file
    #   service = AlgoliaImportService.new
    #   result = HamlParserService.new(file_path).parse
    #   service.process(result, file_path)
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

      # Process the parsed HAML data
      #
      # @param [Hash] data The parsed HAML data
      # @param [String] source_file The source file path that was parsed
      # @return [Boolean] Whether the operation was successful
      #
      def process(data, source_file)
        puts "Processing data from #{source_file}" if debug

        if algolia_configured?
          send_to_algolia(data, source_file)
        else
          save_to_file(data, source_file)
        end
      end

      private

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

        !app_id.nil? && !app_id.empty? && !api_key.nil? && !api_key.empty?
      end

      # Send the data to Algolia
      #
      # @param [Hash] data The data to send
      # @param [String] source_file The source file that was parsed
      # @return [Boolean] Whether the operation was successful
      #
      def send_to_algolia(data, source_file)
        puts "Sending data to Algolia..." if debug

        begin
          require 'algoliasearch-rails'

          # Use the existing client if available, or create a new one
          client = if defined?(AlgoliaSearch) && AlgoliaSearch.client
                    AlgoliaSearch.client
                  else
                    # Initialize a new client if needed
                    ::Algolia::SearchClient.create(
                      ENV['ALGOLIA_APPLICATION_ID'],
                      ENV['ALGOLIA_API_KEY']
                    )
                  end

          # Create an index name based on the file path
          base_name = File.basename(source_file, '.*').gsub(/\.html$/, '')
          index_name = "loco_examples_#{base_name}"
          index = client.init_index(index_name)

          # Add the examples to the index
          if data[:examples]&.any?
            examples = data[:examples].each_with_index.map do |example, i|
              example.merge(
                objectID: "#{base_name}_#{i}",
                component: data[:title],
                file_path: source_file
              )
            end

            index.save_objects(examples)

            puts "Successfully indexed #{examples.length} examples to Algolia (index: #{index_name})" if debug
            # Also save to file as a backup
            save_to_file(data, source_file)
            true
          else
            puts "No examples found to index" if debug
            false
          end
        rescue => e
          puts "Error sending to Algolia: #{e.message}" if debug
          # Fallback to file if Algolia fails
          save_to_file(data, source_file)
          false
        end
      end

      # Save the data to a JSON file
      #
      # @param [Hash] data The data to save
      # @param [String] source_file The source file that was parsed
      # @return [Boolean] Whether the operation was successful
      #
      def save_to_file(data, source_file)
        # Ensure the tmp directory exists
        tmp_dir = File.join(Dir.pwd, 'tmp')
        FileUtils.mkdir_p(tmp_dir)

        # Create a file path based on the source file
        base_name = File.basename(source_file, '.*').gsub(/\.html$/, '')
        output_file = File.join(tmp_dir, "#{base_name}.json")

        begin
          File.write(output_file, JSON.pretty_generate(data))
          puts "Data saved to #{output_file}" if debug
          true
        rescue => e
          puts "Error saving to file: #{e.message}" if debug
          false
        end
      end
    end
  end
end
