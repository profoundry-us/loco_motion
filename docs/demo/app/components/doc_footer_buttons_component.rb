# frozen_string_literal: true

# Renders the "Previous / Next" navigation buttons at the bottom of a doc or
# guide page.
#
# Ordering is derived from the *position* of each page in the section's sorted
# file list — not from arithmetic on the numeric filename prefix. This means the
# links stay correct even when prefixes have gaps or the pages are re-arranged:
# to reorder, just change a file's numeric prefix and the neighbors follow.
class DocFooterButtonsComponent < ApplicationComponent
  attr_reader :current_id, :nav_items

  def initialize(*args, **kws)
    super

    @current_id = config_option(:current_id, "").to_s
    @section = config_option(:section, "guides")

    @nav_items = load_nav_items
    @current_index = @nav_items.index do |item|
      item[:id] == @current_id || item[:slug] == @current_id
    end
  end

  def before_render
    setup_component
  end

  def setup_component
    add_css(:component, "flex justify-between")
  end

  def previous_item
    return nil if @current_index.nil? || @current_index.zero?

    @nav_items[@current_index - 1]
  end

  def next_item
    return nil if @current_index.nil? || @current_index >= @nav_items.length - 1

    @nav_items[@current_index + 1]
  end

  def path_helper
    @section == "guides" ? :guide_path : :doc_path
  end

  private

  # Build the ordered list of pages in this section. Files are sorted by name
  # (so the numeric prefix drives order); partials (leading underscore) are
  # skipped. Each item carries both its full `id` (e.g. "02_docker") and the
  # prefix-less `slug` (e.g. "docker") used to build clean URLs.
  def load_nav_items
    pattern = Rails.root.join("app/views/#{@section}/*.html.*")
    files = Dir.glob(pattern).reject { |f| File.basename(f).start_with?("_") }.sort

    files.map do |file|
      id = File.basename(file, ".*").split(".").first
      slug = id.gsub(/^\d+_/, "")
      title = slug == "llms" ? "LLMs" : slug.humanize
      { id: id, slug: slug, title: title }
    end
  end
end
