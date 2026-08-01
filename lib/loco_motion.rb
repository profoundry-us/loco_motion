# frozen_string_literal: true

require "rails"
require "haml-rails"

require "view_component"

# Load VERSION first: nothing else here requires it, and only path/git
# installs got it by accident (Bundler evaluates their gemspec, whose
# require_relative defines the constant as a side effect). Registry installs
# never run the gemspec, so without this line LocoMotion::VERSION is
# undefined for real consumers.
require "loco_motion/version"

require "loco_motion/errors"
require "loco_motion/configuration"
require "loco_motion/concerns/inspectable_component"
require "loco_motion/component_config"
require "loco_motion/base_component"
require "loco_motion/basic_component"
require "loco_motion/engine"
require "loco_motion/icons/reference"
require "loco_motion/icons/renderer"
require "loco_motion/icons/installer"
require "loco_motion/icons/scanner"
require "loco_motion/icons/vendorer"
require "loco_motion/icons/verifier"
require "loco_motion/migrations/leading_trailing"
require "loco_motion/helpers"

# Load patches
require "loco_motion/patches/view_component/slotable_default_patch"
require "loco_motion/patches/view_component/slot_loco_parent_patch"

require "daisy"

begin
  require "pry" if Rails.env.development?
rescue LoadError
  # Don't throw an error, pry should really only be used while debugging locally
end
