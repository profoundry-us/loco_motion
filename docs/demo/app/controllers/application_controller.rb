# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Acronym titles that `titleize` can't produce (e.g. "llms" -> "Llms").
  # Also used by DocFooterButtonsComponent, which builds its own nav list.
  DOC_TITLE_OVERRIDES = { "llms" => "LLMs", "haml" => "HAML" }.freeze

  before_action :setup_nav_sections

  def home
    render layout: "application"
  end

  private

  def setup_nav_sections
    daisy_components = LocoMotion::COMPONENTS.select { |comp, _config| comp.include? "Daisy" }

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
        items: generate_doc_items("docs")
      },
      {
        title: "Guides",
        icon: "document-text",
        icon_color: "secondary",
        items: generate_doc_items("guides")
      },
      {
        title: "Loco",
        icon: "sparkles",
        icon_color: "info",
        items: [
          {
            title: "Icons",
            path: "/examples/Loco::IconComponent",
            new: LocoMotion::Helpers.new_component?("Loco::IconComponent")
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
                path: "/examples/#{item[:name]}",
                new: LocoMotion::Helpers.new_component?(item[:name])
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
    # Exclude partials (files starting with an underscore)
    files = Dir.glob(pattern).reject { |f| File.basename(f).start_with?("_") }.sort

    # Transform file paths into navigation items
    files.map do |file|
      # Extract the id from the filename (without extension)
      file_id = File.basename(file, ".*").split(".").first

      # Strip any numeric prefix (e.g., "01_introduction" -> "introduction")
      id = file_id.gsub(/^\d+_/, "")

      # The display_id keeps the numeric prefix for proper routing

      # Create a Title Case title from the id, matching the component nav
      title = DOC_TITLE_OVERRIDES.fetch(id, id.titleize)

      # Create the navigation item hash with the appropriate path helper
      # Use the stripped id (without numeric prefix) for paths to match actual URLs
      path = directory == "docs" ? doc_path(id) : guide_path(id)
      { title: title, path: path }
    end
  end
end
