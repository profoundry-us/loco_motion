# frozen_string_literal: true

class DocsController < ApplicationController
  def show
    @doc_id = resolve_doc_id(params[:id])
    render "docs/#{@doc_id}", layout: "application"
  rescue ActionView::MissingTemplate
    render file: Rails.root.join("public/404.html").to_s, status: :not_found
  end

  private

  def resolve_doc_id(id)
    # If the ID doesn't start with a number, try to find a matching file
    # with a numeric prefix
    return id if id =~ /^\d/

    # Look for files that start with a number and contain the requested ID
    Dir[Rails.root.join("app/views/docs/*.html.haml")].each do |file|
      filename = File.basename(file, ".html.haml")
      return filename if filename =~ /^\d+_(.+)/ && Regexp.last_match(1) == id
    end

    # If no match found, return the original ID
    id
  end
end
