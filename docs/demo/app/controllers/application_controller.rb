class ApplicationController < ActionController::Base
  def test
    render html: 'test', layout: true
  end
end
