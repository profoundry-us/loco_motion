class ApplicationController < ActionController::Base

  def home
    render html: "This is the home page! We'll move it into a template file soon...", layout: true
  end

end
