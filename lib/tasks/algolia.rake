# frozen_string_literal: true

namespace :loco do
  namespace :algolia do
    desc "Build and upload Algolia search index"
    task :index => :environment do
      require 'loco_motion/algolia/client'
      require 'loco_motion/algolia/component_indexer'
      require 'loco_motion/algolia/documentation_extractor'
      require 'loco_motion/algolia/example_extractor'
      require 'loco_motion/algolia/search_record_builder'

      puts "Starting Algolia indexing process..."

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

      # Check if LocoMotion::COMPONENTS is defined
      if !defined?(LocoMotion) || !defined?(LocoMotion::COMPONENTS)
        puts "Error: LocoMotion::COMPONENTS not defined. Make sure the LocoMotion gem is loaded."
        exit 1
      end

      # Build component records
      puts "Building component records..."
      builder = LocoMotion::Algolia::SearchRecordBuilder.new(
        root_path: Rails.root.to_s,
        demo_path: ENV['DEMO_PATH'] || Rails.root.to_s
      )
      records = builder.build_records

      # Upload to Algolia
      puts "Uploading #{records.size} components to Algolia..."
      response = index.add_objects(records)

      # Output summary statistics
      puts "Indexing complete! Response: #{response}"
      puts "Indexed #{records.size} components."
      puts "Components by framework:"
      records.group_by { |r| r[:framework] }.each do |framework, comps|
        puts "  #{framework}: #{comps.size} components"
      end

      puts "Components by group:"
      records.group_by { |r| r[:group] }.each do |group, comps|
        puts "  #{group}: #{comps.size} components"
      end

      puts "\nDone! The index is now available for searching."
    rescue StandardError => e
      puts "Error: #{e.message}"
      exit 1
    end

    desc "Clear Algolia search index"
    task :clear => :environment do
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

    desc "Generate a JSON file with the Algolia search data in tmp directory"
    task :dump_json => :environment do
      require 'json'
      require 'fileutils'
      require 'loco_motion/algolia/component_indexer'
      require 'loco_motion/algolia/documentation_extractor'
      require 'loco_motion/algolia/example_extractor'
      require 'loco_motion/algolia/search_record_builder'

      puts "Starting JSON dump process..."

      # Check if LocoMotion::COMPONENTS is defined
      if !defined?(LocoMotion) || !defined?(LocoMotion::COMPONENTS)
        puts "Error: LocoMotion::COMPONENTS not defined. Make sure the LocoMotion gem is loaded."
        exit 1
      end

      # Build component records
      puts "Building component records..."
      builder = LocoMotion::Algolia::SearchRecordBuilder.new(
        root_path: Rails.root.to_s,
        demo_path: ENV['DEMO_PATH'] || Rails.root.to_s
      )
      
      # Capture start time for performance tracking
      start_time = Time.now
      records = builder.build_records
      end_time = Time.now

      # Ensure tmp directory exists
      tmp_dir = File.join(Rails.root, 'tmp')
      FileUtils.mkdir_p(tmp_dir) unless Dir.exist?(tmp_dir)

      # Write to JSON file
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      filename = File.join(tmp_dir, "algolia_data_#{timestamp}.json")
      
      # Create summary data for the file
      summary = {
        metadata: {
          timestamp: Time.now.iso8601,
          total_components: records.size,
          processing_time_seconds: (end_time - start_time).round(2),
          frameworks: records.group_by { |r| r[:framework] }.transform_values(&:size),
          groups: records.group_by { |r| r[:group] }.transform_values(&:size)
        },
        records: records
      }

      puts "Writing #{records.size} records to JSON file..."
      # Write the data to a pretty-formatted JSON file
      File.open(filename, 'w') do |file|
        file.write(JSON.pretty_generate(summary))
      end

      # Output summary statistics
      puts "JSON dump complete! File saved to: #{filename}"
      puts "Processing time: #{(end_time - start_time).round(2)} seconds"
      puts "Dumped #{records.size} components."
      puts "Components by framework:"
      records.group_by { |r| r[:framework] }.sort_by { |framework, _| framework }.each do |framework, comps|
        puts "  #{framework}: #{comps.size} components"
      end

      puts "Components by group:"
      records.group_by { |r| r[:group] }.sort_by { |group, _| group || '' }.each do |group, comps|
        puts "  #{group || 'No Group'}: #{comps.size} components"
      end

      puts "\nDone! You can now inspect the data at: #{filename}"
      puts "\nFile path accessible from host: " + File.join(ENV['HOST_TMP_DIR'] || '/tmp', "algolia_data_#{timestamp}.json")
    rescue StandardError => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n") if ENV['DEBUG']
      exit 1
    end
  end
end
