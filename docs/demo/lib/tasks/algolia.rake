# frozen_string_literal: true

require 'optparse'
require 'fileutils'

namespace :algolia do
  desc 'Index component examples to Algolia'
  task :index => :environment do
    # Default options
    options = {
      skip_upload: false,
      debug: false,
      file_path: nil,
      output_path: nil,
    }

    # Parse command-line arguments
    OptionParser.new do |parser|
      parser.banner = "Usage: rake algolia:index [options]"

      parser.on("-s", "--skip-upload", "Skip uploading to Algolia and only save to file") do
        options[:skip_upload] = true
      end

      parser.on("-d", "--debug", "Enable debug output") do
        options[:debug] = true
      end

      parser.on("-f", "--file FILEPATH", "Path to a specific example file to process") do |path|
        options[:file_path] = path if path && !path.empty?
      end

      parser.on("-o", "--output FILEPATH", "Save the results to a JSON file at the specified path") do |path|
        options[:output_path] = path if path && !path.empty?
      end
    end.parse!(ENV["ARGS"]&.split || [])

    # Setup debug flag
    debug = options[:debug]

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

    # Determine which files to process
    files_to_process = []

    if options[:file_path] && File.exist?(options[:file_path])
      # Process a single file
      puts "Processing single file: #{options[:file_path]}"
      files_to_process = [options[:file_path]]
    else
      # Process all component files
      puts "Processing all component examples"
      files_to_process = Dir.glob(Rails.root.join('app', 'views', 'examples', '**', '*.haml'))

      if files_to_process.empty?
        puts "No example files found"
        return
      end

      puts "Found #{files_to_process.length} example files"
    end

    # Create the services
    import_service = Algolia::AlgoliaImportService.new(debug: debug)
    export_service = Algolia::JsonExportService.new(debug: debug)
    converter_service = Algolia::RecordConverterService.new(debug: debug)
    
    # First, parse all files and collect all records
    all_records = []
    
    files_to_process.each do |file_path|
      records = parse_file(file_path, converter_service, debug)
      if records.any?
        puts "Generated #{records.length} records from #{file_path}"
        all_records.concat(records)
      else
        puts "No records generated from #{file_path}"
      end
    end
    
    # Now handle all records at once
    if all_records.empty?
      puts "\nNo records were generated from any files. Nothing to do."
      return
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

  # Parse a single file and return the records
  def self.parse_file(file_path, converter_service, debug)
    begin
      # Parse the file
      parser = Algolia::HamlParserService.new(file_path, debug)
      result = parser.parse

      # Convert the parsed result to records
      converter_service.convert(result, file_path)
    rescue => e
      puts "Error processing file: #{e.message}"
      puts e.backtrace if debug
      []
    end
  end

  desc "Clear the Algolia search index"
  task :clear, [:force] => [:environment] do |t, args|
    require 'optparse'

    # Parse any additional arguments from ENV['ARGS']
    options = { debug: false, force: false }

    if ENV['ARGS']
      args_array = ENV['ARGS'].split(' ')
      parser = OptionParser.new do |opts|
        opts.on("-d", "--debug", "Enable debug output") do
          options[:debug] = true
        end

        opts.on("-f", "--force", "Skip confirmation prompt") do
          options[:force] = true
        end
      end

      parser.parse!(args_array)
    end

    # Override options with task arguments if provided
    options[:force] = true if args[:force] == 'true'

    # Set debug environment variable
    ENV['DEBUG'] = 'true' if options[:debug]
    debug = options[:debug]

    # Check for Algolia credentials
    unless AlgoliaSearchRails.configuration.application_id && AlgoliaSearchRails.configuration.api_key
      puts "Error: Algolia credentials not found."
      puts "Make sure ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY environment variables are set."
      exit 1
    end

    # Ask for confirmation unless force option is provided
    unless options[:force]
      puts "WARNING: This will clear all Algolia records."
      puts "Are you sure you want to continue? [y/N]"
      input = STDIN.gets.chomp.downcase

      unless input == 'y'
        puts "Operation cancelled."
        exit 0
      end
    end

    # Clear the index
    puts "Clearing Algolia index..."

    # Call the AlgoliaImportService to clear the index
    service = Algolia::AlgoliaImportService.new(debug: debug)
    success = service.clear_index

    if success
      puts "Algolia index cleared successfully."
    else
      puts "Failed to clear Algolia index."
    end
  end
end
