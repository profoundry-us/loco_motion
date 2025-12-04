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

  desc "Generate llms.txt and llms-full.txt documentation files"
  task :llm => :environment do
    require 'optparse'

    # Default options
    options = {
      component: nil,
      output_dir: nil,
    }

    # Parse command-line arguments
    OptionParser.new do |parser|
      parser.banner = "Usage: rake algolia:llm [options]"

      parser.on("-c", "--component COMPONENT_NAME", "Component to process (e.g. 'Daisy::DataDisplay::ChatBubble')") do |name|
        options[:component] = name if name && !name.empty?
      end

      parser.on("-o", "--output DIR", "Save the results to the specified directory (default: public/)") do |path|
        options[:output_dir] = path if path && !path.empty?
      end

      parser.on("-h", "--help", "Display this help message") do
        puts parser
        exit 0
      end
    end.parse!(ENV["ARGS"]&.split || [])

    # Set default output directory if not specified
    if options[:output_dir].nil?
      options[:output_dir] = Rails.root.join('public').to_s
    end

    # Define output paths
    version = LocoMotion::VERSION
    index_filename = "llms-v#{version}.txt"
    full_filename = "llms-full-v#{version}.txt"

    index_path = File.join(options[:output_dir], index_filename)
    full_path = File.join(options[:output_dir], full_filename)

    # Also create versionless copies for convenience/permalinks
    versionless_index_path = File.join(options[:output_dir], "llms.txt")
    versionless_full_path = File.join(options[:output_dir], "llms-full.txt")

    puts "Generating LLM documentation..."
    puts "Output directory: #{options[:output_dir]}"
    puts "Version: #{version}"

    # Create the services
    aggregation_service = Algolia::LlmAggregationService.new
    export_service = Algolia::LlmTextExportService.new

    # Aggregate component data
    components = []

    if options[:component]
      component_name = options[:component]

      if LocoMotion::COMPONENTS.key?(component_name)
        puts "Processing single component: #{component_name}"
        component_data = aggregation_service.aggregate_component(component_name, 0)
        components << component_data if component_data
      else
        puts "Error: Component '#{component_name}' not found in LocoMotion::COMPONENTS registry"
        next
      end
    else
      puts "Processing all components from LocoMotion::COMPONENTS registry"
      components = aggregation_service.aggregate_all
    end

    # Check if we have any components
    if components.empty?
      puts "No components found. No documentation generated."
      next
    end

    puts "Collected #{components.length} component(s)"

    # Export the index file (llms-vX.Y.Z.txt)
    if export_service.export_index(components, index_path)
      puts "Generated: #{index_path}"

      # Create the versionless copy
      FileUtils.cp(index_path, versionless_index_path)
      puts "Generated: #{versionless_index_path} (copy)"
    else
      puts "Error generating index file"
    end

    # Export the full content file (llms-full-vX.Y.Z.txt)
    if export_service.export_full(components, full_path)
      puts "Generated: #{full_path}"

      # Create the versionless copy
      FileUtils.cp(full_path, versionless_full_path)
      puts "Generated: #{versionless_full_path} (copy)"

      # Run content validation checks
      puts "\nRunning content validation checks..."
      validate_content_quality(full_path)
    else
      puts "Error generating full content file"
    end

    puts "\nDocumentation generation complete!"
  end

  # Validate content quality of generated documentation
  #
  # @param file_path [String] Path to the generated documentation file
  #
  def self.validate_content_quality(file_path)
    return unless File.exist?(file_path)

    content = File.read(file_path)
    issues = []

    # Check for HAML syntax contamination in component descriptions only
    if content.include?('succeed "." do')
      issues << "Found HAML syntax contamination in descriptions"
    end

    # Check for component helper calls in component descriptions (not usage patterns)
    # Split by component sections to avoid false positives in usage patterns
    component_sections = content.split('=== Component:')
    component_sections.shift # Skip the header section

    component_sections.each do |section|
      # Look for descriptions before "API Signature:" or "Helpers:"
      description_part = section.split(/API Signature:|Helpers:/).first

      if description_part.include?('daisy_link(') || description_part.include?('hero_icon(')
        issues << "Found component helper calls in component descriptions"
        break
      end
    end

    # Check for documentation boilerplate in code examples
    if content.include?('doc_example(') || content.include?('example_css:')
      issues << "Found documentation boilerplate in code examples"
    end

    # Check for truncated descriptions
    lines = content.split("\n")
    lines.each do |line|
      if line.match?(/^\*\*[^*]+\*\*:\s*.*\.\.\.$/) && !line.include?("URL:")
        issues << "Found truncated description: #{line[0..50]}..."
        break
      end
    end

    # Report results
    if issues.empty?
      puts "✅ All content quality checks passed!"
    else
      puts "⚠️  Content quality issues found:"
      issues.each { |issue| puts "   - #{issue}" }
      puts "   Consider reviewing the generated documentation"
    end
  end
end
