require "rails"
require "haml-rails"
require "heroicons-rails"

require Gem::Specification.find_by_name("heroicons-rails").gem_dir + "/app/helpers/heroicons/icons_helper.rb"

require "view_component"

require "loco_motion/errors"
require "loco_motion/configuration"
require "loco_motion/component_config"
require "loco_motion/base_component"
require "loco_motion/basic_component"
require "loco_motion/engine"
require "loco_motion/helpers"

require "hero"
require "daisy"

begin
  require "pry" if Rails.env.development?
rescue LoadError
  # Don't throw an error, pry should really only be used while debugging locally
end
