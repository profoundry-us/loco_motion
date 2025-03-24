# frozen_string_literal: true

module Algolia
  # Converts parsed HAML data to searchable records for Algolia
  #
  # This service is responsible for transforming parsed HAML data into properly
  # structured records for Algolia search. It creates both component and example
  # records with appropriate URLs and metadata.
  #
  # @loco_example Convert parsed data to records
  #   converter = Algolia::RecordConverterService.new
  #   records = converter.convert(parsed_data, "app/views/examples/buttons.html.haml", "Daisy::Actions::ButtonComponent")
  #
  class RecordConverterService
    # Initialize the converter service
    #
    def initialize
    end

    # Convert parsed HAML data to searchable records
    #
    # @param data [Hash] The parsed HAML data
    # @param source_file [String] The source file path that was parsed
    # @param component_name [String] The fully qualified component name (e.g. "Daisy::Actions::ButtonComponent")
    #
    # @return [Array<Hash>] The converted records for Algolia
    #
    def convert(data, source_file, component_name, position)
      Rails.logger.debug "Converting data for #{component_name} to searchable records..."

      # Get component information from the component_name
      split = component_name.split("::")
      framework = split[0]
      section = (split.length == 3 ? split[1] : "")
      base_name = split.last
      url = LocoMotion::Helpers.component_example_path(component_name)

      records = []

      # Create a record for the component itself
      if data[:title].present?
        component_record = {
          type: 'component',
          objectID: base_name,
          framework: framework,
          section: section,
          component: base_name,
          title: data[:title],
          description: data[:description],
          url: url,
          file_path: source_file,
          priority: (position + 1)
        }

        records << component_record
      end

      # Create records for each example
      if data[:examples].present?
        data[:examples].each_with_index do |example, idx|
          next unless example[:title].present?

          # Create a separate record for this example
          example_record = {
            type: 'example',
            objectID: "#{base_name}-#{example[:anchor]}",
            framework: framework,
            section: section,
            component: base_name,
            title: example[:title],
            description: example[:description],
            code: example[:code],
            url: "#{url}##{example[:anchor]}",
            file_path: source_file,

            # Guessing we won't have more than 1000 components
            priority: ((position + 1) * 1000) + idx
          }

          records << example_record
        end
      end

      Rails.logger.debug "Generated #{records.length} records"
      records
    end
  end
end
