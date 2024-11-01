class ApplicationController < ActionController::Base

  def home
    render layout: "application"
  end

end
