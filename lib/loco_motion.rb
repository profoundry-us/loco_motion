require "rails"
require "haml-rails"
require "rails_heroicon"

require Gem::Specification.find_by_name("rails_heroicon").gem_dir + "/lib/rails_heroicon/helper.rb"

require "view_component"

require "loco_motion/errors"
require "loco_motion/configuration"
require "loco_motion/component_config"
require "loco_motion/base_component"
require "loco_motion/basic_component"
require "loco_motion/engine"
require "loco_motion/helpers"

# Load patches
require "loco_motion/patches/view_component/slotable_default_patch"
require "loco_motion/patches/view_component/slot_loco_parent_patch"

require "hero"
require "daisy"

begin
  require "pry" if Rails.env.development?
rescue LoadError
  # Don't throw an error, pry should really only be used while debugging locally
end
