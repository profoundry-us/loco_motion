class ApiDocsController < ApplicationController

  def index
    host = ENV.fetch("LOCO_DOCS_HOST", "http://localhost:8808/docs")

    redirect_to host
  end

end
