require 'spec_helper'
require 'bundler'
require "view_component/test_helpers"
require "view_component/system_test_helpers"
# require "capybara/rspec"

require 'loco_motion'

Bundler.require :default, :development

# If you're using all parts of Rails:
# Combustion.initialize! :all
# Or, load just what you need:
Combustion.initialize! :action_controller, :action_view

require 'rspec/rails'
# If you're using Capybara:
# require 'capybara/rails'

class ApplicationController < ActionController::Base
end

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  # config.include Capybara::RSpecMatchers, type: :component

  # Some of the tests utilize various helpers such as tag, content_tag, and
  # heroicon (which users the raw helper)
  config.include RailsHeroicon::Helper, type: :component
  config.include ActionView::Helpers::TagHelper, type: :component
  config.include ActionView::Helpers::OutputSafetyHelper, type: :component
end
