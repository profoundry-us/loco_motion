# frozen_string_literal: true

module Algolia
  # Converts parsed HAML data to searchable records for Algolia
  class RecordConverterService
    attr_reader :debug

    # Initialize the converter service
    #
    # @param debug [Boolean] Whether to output debug information
    def initialize(debug: false)
      @debug = debug
    end

    # Convert parsed HAML data to searchable records
    #
    # @param [Hash] data The parsed HAML data
    # @param [String] source_file The source file path that was parsed
    # @return [Array<Hash>] The converted records for Algolia
    #
    def convert(data, source_file)
      return [] if data.nil? || data[:examples].nil?

      puts "Converting data from #{source_file} to searchable records..." if debug

      # Create an index name based on the file path
      base_name = File.basename(source_file, '.*').gsub(/\.html$/, '')

      # Convert examples to records
      data[:examples].each_with_index.map do |example, i|
        example.merge(
          objectID: "#{base_name}_#{i}",
          component: base_name,
          url: "/examples/daisy/#{base_name}",
          anchor: example[:anchor],
          file_path: source_file
        )
      end
    end
  end
end
