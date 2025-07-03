class DocFooterButtonsComponent < ApplicationComponent
  attr_reader :current_id, :current_num, :nav_items

  def initialize(*args, **kws)
    super

    @current_id = config_option(:current_id, "")
    @section = config_option(:section, "guides")
    
    # Extract the number from the current ID (e.g., "01_docker" -> 1)
    @current_num = @current_id.to_s.match(/^(\d+)_/).to_a[1].to_i
    
    # Load navigation items once
    @nav_items = load_nav_items
  end

  def before_render
    setup_component
  end

  def setup_component
    add_css(:component, "flex justify-between")
  end

  def show_previous?
    current_num > 1
  end

  def previous_id
    return nil unless current_num > 1
    
    # Use string interpolation with zero-padding instead of format
    prev_num = "#{current_num - 1}".rjust(2, '0')
    
    # Find the item in the nav items that has this number prefix
    nav_items.find { |item| item[:id].start_with?(prev_num) }&.dig(:id)
  end

  def next_id
    # Use string interpolation with zero-padding instead of format
    next_num = "#{current_num + 1}".rjust(2, '0')
    
    # Find the item in the nav items that has this number prefix
    nav_items.find { |item| item[:id].start_with?(next_num) }&.dig(:id)
  end

  def previous_title
    return nil unless previous_id

    # Get the title by removing the numeric prefix and converting to title case
    previous_id.gsub(/^\d+_/, '').humanize
  end

  def next_title
    return nil unless next_id

    # Get the title by removing the numeric prefix and converting to title case
    next_id.gsub(/^\d+_/, '').humanize
  end

  def path_helper
    @section == "guides" ? :guide_path : :doc_path
  end

  private

  def load_nav_items
    # Load all files in the section directory to get the navigation items
    pattern = Rails.root.join("app/views/#{@section}/*.html.*")
    files = Dir.glob(pattern).sort

    files.map do |file|
      file_id = File.basename(file, ".*").split(".").first
      id = file_id
      { id: id, title: id.gsub(/^\d+_/, '').humanize }
    end
  end
end
