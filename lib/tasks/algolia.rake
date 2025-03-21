# frozen_string_literal: true

namespace :loco do
  namespace :algolia do
    desc "Parse and output Algolia search data (auto-indexes if credentials available) (DEPRECATED: Use bin/algolia_index instead)"
    task :index => :environment do
      # Display deprecation warning
      puts "\e[31mDEPRECATED:\e[0m This rake task is deprecated and will be removed in a future version."
      puts "Please use the \e[1mbin/algolia_index\e[0m binary instead."
      puts
      
      require 'loco_motion/algolia/client'
      require 'loco_motion/algolia/component_indexer'
      require 'loco_motion/algolia/documentation_extractor'
      require 'loco_motion/algolia/haml_parser_service'
      require 'loco_motion/algolia/search_record_builder'
      require 'json'
      require 'fileutils'

      puts "Starting Algolia data processing..."

      # Check for Algolia credentials
      application_id = ENV['ALGOLIA_APPLICATION_ID']
      api_key = ENV['ALGOLIA_API_KEY']
      has_credentials = application_id.present? && api_key.present?
      
      if has_credentials
        puts "Algolia credentials found. Will upload data to Algolia."
        # Initialize Algolia client
        client = LocoMotion::Algolia::Client.new
        index = client.index('components')
      else
        puts "No Algolia credentials found. Will generate JSON file only."
      end

      # Check if LocoMotion::COMPONENTS is defined
      if !defined?(LocoMotion) || !defined?(LocoMotion::COMPONENTS)
        puts "Error: LocoMotion::COMPONENTS not defined. Make sure the LocoMotion gem is loaded."
        exit 1
      end

      # Build component records
      puts "Building component records..."
      start_time = Time.now
      builder = LocoMotion::Algolia::SearchRecordBuilder.new(
        root_path: Rails.root.to_s,
        demo_path: ENV['DEMO_PATH'] || Rails.root.to_s
      )
      records = builder.build_records
      end_time = Time.now
      processing_time = (end_time - start_time).round(2)

      # If we have credentials, upload to Algolia
      if has_credentials
        puts "Uploading #{records.size} components to Algolia..."
        response = index.add_objects(records)
        puts "Indexing complete! Response: #{response}"
      end

      # Regardless of credentials, write to a JSON file for reference
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      tmp_dir = File.join(Rails.root, 'tmp')
      FileUtils.mkdir_p(tmp_dir) unless Dir.exist?(tmp_dir)
      filename = File.join(tmp_dir, "algolia_data_#{timestamp}.json")
      
      # Create summary data for the file
      summary = {
        metadata: {
          timestamp: Time.now.iso8601,
          total_components: records.size,
          processing_time_seconds: processing_time,
          frameworks: records.group_by { |r| r[:framework] }.transform_values(&:size),
          groups: records.group_by { |r| r[:group] }.transform_values(&:size),
          uploaded_to_algolia: has_credentials
        },
        records: records
      }
      
      # Write the data to a pretty-formatted JSON file
      File.open(filename, 'w') do |file|
        file.write(JSON.pretty_generate(summary))
      end

      # Output summary statistics
      puts "Processing complete! File saved to: #{filename}"
      puts "Processing time: #{processing_time} seconds"
      puts "Processed #{records.size} components."
      puts "Components by framework:"
      records.group_by { |r| r[:framework] }.sort_by { |framework, _| framework }.each do |framework, comps|
        puts "  #{framework}: #{comps.size} components"
      end

      puts "Components by group:"
      records.group_by { |r| r[:group] }.sort_by { |group, _| group || '' }.each do |group, comps|
        puts "  #{group || 'No Group'}: #{comps.size} components"
      end

      puts "\nDone! #{has_credentials ? 'Data uploaded to Algolia and saved locally.' : 'Data saved to JSON file.'}"
      puts "File path: #{filename}"
    rescue StandardError => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n") if ENV['DEBUG']
      exit 1
    end

    desc "Clear Algolia search index (DEPRECATED: Use bin/algolia_clear instead)"
    task :clear => :environment do
      # Display deprecation warning
      puts "\e[31mDEPRECATED:\e[0m This rake task is deprecated and will be removed in a future version."
      puts "Please use the \e[1mbin/algolia_clear\e[0m binary instead."
      puts
      
      require 'loco_motion/algolia/client'

      puts "Clearing Algolia index..."

      # Check for Algolia credentials
      application_id = ENV['ALGOLIA_APPLICATION_ID']
      api_key = ENV['ALGOLIA_API_KEY']

      if application_id.nil? || api_key.nil?
        puts "Error: Algolia credentials not configured!"
        puts "Please set ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY environment variables."
        exit 1
      end

      # Initialize Algolia client
      client = LocoMotion::Algolia::Client.new
      index = client.index('components')

      # Clear the index
      response = index.clear_objects

      puts "Index cleared! Response: #{response}"
    rescue StandardError => e
      puts "Error: #{e.message}"
      exit 1
    end

    desc "Parse and return data for a specific HAML file (DEPRECATED: Use bin/algolia_index <file_path> instead)"
    task :parse_file => :environment do
      # Display deprecation warning
      puts "\e[31mDEPRECATED:\e[0m This rake task is deprecated and will be removed in a future version."
      puts "Please use the \e[1mbin/algolia_index <file_path>\e[0m binary instead."
      puts
      
      require 'loco_motion/algolia/haml_parser_service'
      require 'json'
      
      # Get the file path from the command line arguments
      file_path = ENV['FILE_PATH']
      debug = ENV['DEBUG'] == 'true'
      
      if file_path.nil?
        puts "Error: No file path provided. Use FILE_PATH=path/to/file.html.haml"
        exit 1
      end
      
      unless File.exist?(file_path)
        puts "Error: File not found: #{file_path}"
        exit 1
      end
      
      # Set debug environment variable if requested
      if debug
        puts "Starting to parse HAML file: #{file_path}"
        puts ""
        puts "File contents:"
        puts File.read(file_path)
        puts "End of file contents"
        puts ""
      end
      
      # Create the parser and parse the file
      parser = LocoMotion::Algolia::HamlParserService.new(file_path, debug)
      result = parser.parse
      
      # Print the result
      if debug
        puts "# Result from parsing #{file_path}:\n"
        require 'pp'
        pp result
      else
        # Output as a pretty-formatted JSON string
        puts JSON.pretty_generate(result)
      end
    end
  end
end
