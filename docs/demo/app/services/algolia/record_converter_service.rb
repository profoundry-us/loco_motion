# frozen_string_literal: true

module Algolia
  # Converts parsed HAML data to searchable records for Algolia
  #
  # This service is responsible for transforming parsed HAML data into properly
  # structured records for Algolia search. It creates both component and example
  # records with appropriate URLs and metadata.
  #
  # @loco_example Convert parsed data to records
  #   converter = Algolia::RecordConverterService.new(debug: true)
  #   records = converter.convert(parsed_data, "app/views/examples/buttons.html.haml")
  #
  class RecordConverterService
    attr_reader :debug

    # Initialize the converter service
    #
    # @param debug [Boolean] Whether to output debug information
    #
    def initialize(debug: false)
      @debug = debug
    end

    # Convert parsed HAML data to searchable records
    #
    # @param data [Hash] The parsed HAML data
    # @param source_file [String] The source file path that was parsed
    #
    # @return [Array<Hash>] The converted records for Algolia
    #
    def convert(data, source_file)
      return [] if data.nil?

      puts "Converting data from #{source_file} to searchable records..." if debug

      # Extract component information from file path
      component_info = extract_component_info(source_file)

      records = []

      # Create a record for the component itself
      if data[:title].present?
        component_record = {
          objectID: component_info[:base_name],
          type: 'component',
          component: component_info[:base_name],
          title: data[:title],
          description: data[:description],
          url: component_info[:component_url],
          file_path: source_file
        }

        records << component_record
      end

      # Create records for each example
      if data[:examples].present?
        example_records = data[:examples].map do |example|
          {
            objectID: "#{component_info[:base_name]}_#{example[:anchor]}",
            type: 'example',
            component: component_info[:base_name],
            title: example[:title],
            description: example[:description],
            code: example[:code],
            url: "#{component_info[:component_url]}##{example[:anchor]}",
            file_path: source_file
          }
        end

        records.concat(example_records)
      end

      records
    end

    private

    # Extract component information from file path
    #
    # @param file_path [String] The file path to extract component info from
    # @return [Hash] A hash containing base_name and component_url
    #
    def extract_component_info(file_path)
      # Extract the base name from the file path
      base_name = File.basename(file_path, '.*').gsub(/\.html$/, '')

      # Extract directory structure for component namespace
      path_parts = file_path.split('/')
      examples_index = path_parts.index('examples')

      if examples_index && examples_index < path_parts.length - 1
        namespace_parts = path_parts[(examples_index + 1)...-1] # Get directories between 'examples' and the file name

        # Build class name for URL
        namespace = namespace_parts.map { |part| part.capitalize }.join('::')

        # For the component name, use the base_name
        component_name = base_name.split('_').map(&:capitalize).join

        # For example: Daisy::Actions::DropdownComponent
        component_class = "#{namespace}::#{component_name}Component"
        component_url = "/examples/#{component_class}"
      else
        # Fallback to the old format if we can't determine the class structure
        component_url = "/examples/daisy/#{base_name}"
      end

      {
        base_name: base_name,
        component_url: component_url
      }
    end
  end
end
