class ApplicationController < ActionController::Base

  before_action :setup_nav_sections

  def home
    render layout: "application"
  end

  private

  def setup_nav_sections
    daisy_components = LocoMotion::COMPONENTS.select { |comp,config| comp.include? "Daisy" }

    # Group daisy components by their group
    grouped_components = {}
    daisy_components.each do |comp, config|
      group = config[:group]
      grouped_components[group] ||= []
      grouped_components[group] << { name: comp, config: config }
    end

    # Sort groups by name
    sorted_groups = grouped_components.keys.sort

    @nav_sections = [
      {
        title: "Docs",
        icon: "book-open",
        icon_color: "accent",
        items: generate_doc_items('docs')
      },
      {
        title: "Guides",
        icon: "document-text",
        icon_color: "secondary",
        items: generate_doc_items('guides')
      },
      {
        title: "Hero",
        icon: "shield-check",
        icon_color: "info",
        items: [
          {
            title: "Icons",
            path: "/examples/Hero::IconComponent"
          }
        ]
      },
      {
        title: "Daisy",
        icon: "square-3-stack-3d",
        icon_color: "primary",
        items: sorted_groups.map do |group|
          {
            title: group,
            is_group: true,
            items: grouped_components[group].map do |item|
              {
                title: item[:config][:title],
                path: "/examples/#{item[:name]}"
              }
            end
          }
        end
      }
    ]
  end

  # Dynamically generate navigation items based on files in the specified directory
  def generate_doc_items(directory)
    # Pattern to match all html/haml files in the specified directory
    pattern = Rails.root.join("app/views/#{directory}/*.html.*")

    # Find all matching files and sort them
    files = Dir.glob(pattern).sort

    # Transform file paths into navigation items
    files.map do |file|
      # Extract the id from the filename (without extension)
      file_id = File.basename(file, ".*").split('.').first

      # Strip any numeric prefix (e.g., "01_introduction" -> "introduction")
      id = file_id.gsub(/^\d+_/, '')

      # The display_id keeps the numeric prefix for proper routing
      display_id = file_id

      # Create a title from the id (capitalize, replace underscores with spaces)
      title = id.humanize

      # Create the navigation item hash with the appropriate path helper
      path = directory == 'docs' ? doc_path(display_id) : guide_path(display_id)
      { title: title, path: path }
    end
  end
end
