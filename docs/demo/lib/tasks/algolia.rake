# frozen_string_literal: true

namespace :algolia do
  desc "Index components to Algolia"
  task :index, [:file_path] => [:environment] do |t, args|
    require 'optparse'

    # Parse any additional arguments from ENV['ARGS']
    options = { debug: false, output_path: nil, skip_upload: false }

    if ENV['ARGS']
      args_array = ENV['ARGS'].split(' ')
      parser = OptionParser.new do |opts|
        opts.on("-d", "--debug", "Enable debug output") do
          options[:debug] = true
        end

        opts.on("-o", "--output PATH", "Save results to a JSON file") do |path|
          options[:output_path] = path
        end

        opts.on("-s", "--skip-upload", "Skip uploading to Algolia") do
          options[:skip_upload] = true
        end
      end

      parser.parse!(args_array)
    end

    # Set debug environment variable
    ENV['DEBUG'] = 'true' if options[:debug]
    debug = options[:debug]

    # Get the file path from task arguments
    file_path = args[:file_path]

    # Check Algolia configuration
    application_id = ENV['ALGOLIA_APPLICATION_ID']
    api_key = ENV['ALGOLIA_API_KEY']

    algolia_configured = !application_id.nil? && !api_key.nil? && !application_id.empty? && !api_key.empty?

    if algolia_configured
      puts "Algolia credentials found. Will upload data to Algolia."
    else
      puts "Algolia credentials not found. Will only generate JSON output."
      options[:skip_upload] = true

      # Set a default output path if none specified
      options[:output_path] ||= "tmp/components.json" if options[:output_path].nil?
    end

    # Process a single file or all components
    if file_path && File.exist?(file_path)
      puts "Processing single file: #{file_path}"

      # Parse the file
      parser = Algolia::HamlParserService.new(file_path, debug)
      result = parser.parse

      # Process the result
      import_service = Algolia::AlgoliaImportService.new(debug: debug)
      import_service.process(result, file_path)

      puts "Processing complete!"
    else
      # Process all components
      puts "Building component records..."
      start_time = Time.now

      # Use the component indexer to build records
      indexer = Algolia::ComponentIndexer.new
      records = indexer.build_search_records

      end_time = Time.now
      processing_time = (end_time - start_time).round(2)

      # If we have credentials and records, upload to Algolia
      if algolia_configured && !options[:skip_upload] && !records.empty?
        puts "Uploading #{records.size} components to Algolia..."
        index = Algolia::Index.new('components')
        response = index.save_objects(records)
        puts "Indexing complete! Response: #{response}"
      end

      # Always write to a JSON file for reference if output path specified
      if options[:output_path]
        timestamp = Time.now.strftime('%Y%m%d%H%M%S')
        tmp_dir = Rails.root.join('tmp')
        FileUtils.mkdir_p(tmp_dir) unless File.directory?(tmp_dir)
        filename = options[:output_path]

        # Create summary data for the file
        summary = {
          metadata: {
            timestamp: Time.now.iso8601,
            total_components: records.size,
            processing_time_seconds: processing_time,
            uploaded_to_algolia: algolia_configured && !options[:skip_upload] ? Time.now.iso8601 : nil
          },
          records: records
        }

        # Write the data to a pretty-formatted JSON file
        File.open(filename, 'w') do |file|
          file.write(JSON.pretty_generate(summary))
        end

        puts "File saved to: #{filename}"
      end

      # Output summary statistics
      puts "Processing time: #{processing_time} seconds"
      puts "Processed #{records.size} components."
      puts "Done! #{algolia_configured && !options[:skip_upload] ? 'Data uploaded to Algolia and saved locally.' : 'Data saved to JSON file.'}"
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
    application_id = ENV['ALGOLIA_APPLICATION_ID']
    api_key = ENV['ALGOLIA_API_KEY']

    if application_id.nil? || api_key.nil? || application_id.empty? || api_key.empty?
      puts "Error: Algolia credentials not configured!"
      puts "Please set ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY environment variables."
      exit 1
    end

    # Initialize Algolia client
    index = Algolia::Index.new('components')

    # Ask for confirmation unless force flag is set
    unless options[:force]
      puts "WARNING: This will permanently delete all records in the Algolia '#{index.name}' index."
      print "Are you sure you want to continue? [y/N] "
      confirmation = $stdin.gets.chomp.downcase
      unless confirmation == 'y'
        puts "Operation cancelled."
        exit 0
      end
    end

    # Clear the index
    puts "Clearing Algolia index..."
    response = index.clear_objects

    puts "Index cleared! Response: #{response}"
  end
end
