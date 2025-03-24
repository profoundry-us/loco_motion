# frozen_string_literal: true

require 'optparse'
require 'fileutils'

namespace :algolia do
  desc 'Index component examples to Algolia'
  task :index => :environment do
    # Default options
    options = {
      skip_upload: false,
      component: nil,
      output_path: nil,
    }

    # Parse command-line arguments
    OptionParser.new do |parser|
      parser.banner = "Usage: rake algolia:index [options]"

      parser.on("-s", "--skip-upload", "Skip uploading to Algolia and only save to file") do
        options[:skip_upload] = true
      end

      parser.on("-c", "--component COMPONENT_NAME", "Component to process (e.g. 'Daisy::DataDisplay::ChatBubble')") do |name|
        options[:component] = name if name && !name.empty?
      end

      parser.on("-o", "--output FILEPATH", "Save the results to a JSON file at the specified path") do |path|
        options[:output_path] = path if path && !path.empty?
      end
    end.parse!(ENV["ARGS"]&.split || [])

    # Check for Algolia credentials
    application_id = ENV['ALGOLIA_APPLICATION_ID']
    api_key = ENV['ALGOLIA_API_KEY']
    algolia_configured = !application_id.blank? && !api_key.blank?

    if algolia_configured
      puts "Algolia credentials found."
    else
      puts "No Algolia credentials found. Falling back to JSON file."
      # Force skip_upload if no credentials
      options[:skip_upload] = true
    end

    # Use tmp/algolia directory for temporary files if no specific output path is given
    if options[:output_path].nil?
      tmp_dir = Rails.root.join('tmp', 'algolia')
      FileUtils.mkdir_p(tmp_dir)
      options[:output_path] = tmp_dir.join('algolia_index.json').to_s
    end

    # Create the services
    import_service = Algolia::AlgoliaImportService.new
    export_service = Algolia::JsonExportService.new
    converter_service = Algolia::RecordConverterService.new

    # First, determine which components to process
    all_records = []
    components_to_process = []

    # Determine which components to process based on options
    if options[:component]
      # Process a specific component if it exists in the registry
      component_name = options[:component]

      if LocoMotion::COMPONENTS.key?(component_name)
        components_to_process = [component_name]
        puts "Processing single component: #{component_name}"
      else
        puts "Error: Component '#{component_name}' not found in LocoMotion::COMPONENTS registry"
        next
      end
    else
      # Process all components in the registry
      components_to_process = LocoMotion::COMPONENTS.keys
      component_count = components_to_process.size
      puts "Processing all #{component_count} components from LocoMotion::COMPONENTS registry"
    end

    # Process each component
    components_to_process.each_with_index do |component_name, position|
      puts "\n\nProcessing component: #{component_name}"

      metadata = LocoMotion::COMPONENTS[component_name]
      split = component_name.split('::')

      framework = split[0].underscore
      group_path = split.length == 3 ? split[1].underscore : ""
      example_name = metadata[:example]

      # Construct the file path for this component including the framework
      file_path = Rails.root.join('app', 'views', 'examples', framework, group_path, "#{example_name}.html.haml").to_s

      # Debug the path we're looking for
      puts "Looking for example file at: #{file_path}"

      # Check to see if the file exists
      if File.exist?(file_path)
        puts "Found example file at: #{file_path}"
        records = process_file(file_path, component_name, converter_service, position)

        if records.any?
          puts "Generated #{records.length} records from #{component_name}"
          all_records.concat(records)
        else
          puts "[WARN] No records generated from #{component_name}"
        end
      else
        puts "[WARN] No file found!!!"
      end
    end

    # Now handle all records at once
    if all_records.empty?
      puts "\nNo records were generated from any components. Nothing to do."
      next
    end

    puts "\nTotal records collected: #{all_records.length}"

    # Upload to Algolia if credentials are available and not skipped
    if !options[:skip_upload] && algolia_configured
      puts "Uploading all records to Algolia..."
      success = import_service.import(all_records, "batch_upload")
      puts success ? "Upload to Algolia completed successfully" : "Failed to upload to Algolia"
    else
      puts "Skipping upload to Algolia as requested"
    end

    # Save to JSON file
    if options[:output_path]
      puts "Saving all records to JSON..."
      success = export_service.export(all_records, options[:output_path])
      puts success ? "Data saved to #{options[:output_path]}" : "Failed to save data to #{options[:output_path]}"
    end

    puts "\nAll processing complete!"
  end

  # Process a single file and return the records
  def self.process_file(file_path, component_name, converter_service, position)
    begin
      # Parse the file
      parser = Algolia::HamlParserService.new(file_path)
      result = parser.parse

      # Convert the parsed result to records, passing the component name
      converter_service.convert(result, file_path, component_name, position)
    rescue => e
      puts "Error processing file: #{e.message}"
      puts e.backtrace
      []
    end
  end

  desc "Clear the Algolia search index"
  task :clear, [:force] => [:environment] do |t, args|
    require 'optparse'

    # Parse any additional arguments from ENV['ARGS']
    options = { force: false, index_name: 'components' }

    if ENV['ARGS']
      args_array = ENV['ARGS'].split(' ')
      parser = OptionParser.new do |opts|
        opts.on("-f", "--force", "Skip confirmation prompt") do
          options[:force] = true
        end

        opts.on("-i", "--index INDEX", "Specify the index name to clear") do |name|
          options[:index_name] = name
        end
      end

      parser.parse!(args_array)
    end

    # Override options with task arguments if provided
    options[:force] = true if args[:force] == 'true'

    # Ask for confirmation unless force option is provided
    unless options[:force]
      puts "WARNING: This will clear all Algolia records from index '#{options[:index_name]}'."
      puts "Are you sure you want to continue? [y/N]"
      input = STDIN.gets.chomp.downcase

      unless input == 'y'
        puts "Operation cancelled."
        exit 0
      end
    end

    # Clear the index
    puts "Clearing Algolia index: #{options[:index_name]}..."

    # Call the AlgoliaImportService to clear the index
    service = Algolia::AlgoliaImportService.new
    success = service.clear_index(options[:index_name])

    if success
      puts "Algolia index '#{options[:index_name]}' cleared successfully."
    else
      puts "Failed to clear Algolia index '#{options[:index_name]}'."
    end
  end
end
