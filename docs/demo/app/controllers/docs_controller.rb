class DocsController < ApplicationController

  def show
    @doc_id = params[:id]
    render "docs/#{@doc_id}", layout: "application"
  rescue ActionView::MissingTemplate
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

end
