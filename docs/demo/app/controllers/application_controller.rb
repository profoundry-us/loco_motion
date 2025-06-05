class ApplicationController < ActionController::Base

  def home
    @is_home_page = true
    render layout: "application"
  end

end
