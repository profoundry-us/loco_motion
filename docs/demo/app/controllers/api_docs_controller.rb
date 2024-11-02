class ApiDocsController < ApplicationController

  def index
    host = ENV.fetch("LOCO_DOCS_HOST", "http://localhost:8808/docs")

    # We specifically want to allow another host because the prod docs are on
    # a different URL
    redirect_to host, allow_other_host: true
  end

end
