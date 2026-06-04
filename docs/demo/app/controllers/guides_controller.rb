# frozen_string_literal: true

class GuidesController < ApplicationController
  def show
    raw_id = params[:id].to_s

    # Sanitize the incoming guide id to avoid directory-traversal or other unsafe template paths.
    # Allow only letters, numbers, underscores and dashes.
    sanitized_id = raw_id.gsub(/[^A-Za-z0-9_-]/, "")

    @guide_id = resolve_guide_id(sanitized_id)

    render "guides/#{@guide_id}", layout: "application"
  rescue ActionView::MissingTemplate
    render file: Rails.root.join("public/404.html").to_s, layout: false, status: :not_found
  end

  private

  def resolve_guide_id(id)
    # If the ID doesn't start with a number, try to find a matching file
    # with a numeric prefix
    return id if id =~ /^\d/

    # Look for files that start with a number and contain the requested ID
    Dir[Rails.root.join("app/views/guides/*.html.haml")].each do |file|
      filename = File.basename(file, ".html.haml")
      return filename if filename =~ /^\d+_(.+)/ && Regexp.last_match(1) == id
    end

    # If no match found, return the original ID
    id
  end
end
