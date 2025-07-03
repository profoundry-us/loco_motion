class GuidesController < ApplicationController

  def show
    raw_id = params[:id].to_s

    # Sanitize the incoming guide id to avoid directory-traversal or other unsafe template paths.
    # Allow only letters, numbers, underscores and dashes.
    @guide_id = raw_id.gsub(/[^A-Za-z0-9_-]/, '')

    render "guides/#{@guide_id}", layout: "application"
  rescue ActionView::MissingTemplate
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

end
