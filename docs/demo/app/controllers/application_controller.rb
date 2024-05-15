class ApplicationController < ActionController::Base
  def test
    render html: 'This is a test!', layout: true
  end
end
