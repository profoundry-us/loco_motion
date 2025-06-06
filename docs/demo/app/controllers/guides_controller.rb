class GuidesController < ApplicationController

  def show
    @guide_id = params[:id]
    render "guides/#{@guide_id}", layout: "application"
  rescue ActionView::MissingTemplate
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

end
