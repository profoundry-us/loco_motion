# spec/rails_helper.rb
require "loco_motion"
require "rails"
require "view_component/test_helpers"
require "view_component/system_test_helpers"
# require "capybara/rspec"

class ApplicationController < ActionController::Base
end

RSpec.configure do |config|
  LocoMotion.require_components

  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  # config.include Capybara::RSpecMatchers, type: :component
end
