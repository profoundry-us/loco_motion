class ApiDocsController < ApplicationController

  def index
    # We specifically want to allow another host because the prod docs are on
    # a different URL
    redirect_to Rails.configuration.api_docs_host, allow_other_host: true
  end

end
