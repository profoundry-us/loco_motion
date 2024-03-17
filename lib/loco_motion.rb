require "rails"
require "haml-rails"
require "heroicons-rails"

require Gem::Specification.find_by_name("heroicons-rails").gem_dir + "/app/helpers/heroicons/icons_helper.rb"

require "view_component"
require "loco_motion/engine"
require "loco_motion/errors"
require "loco_motion/component_config"
require "loco_motion/base_component"

#
# Module containing all features related to the LocoMotion gem.
#
module LocoMotion
  #
  # Holds all Action-type components.
  #
  module Actions; end

  #
  # Holds all Data-type components.
  #
  module Data; end

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    # Mostly used for internal testing; not needed in Rails
    def require_components
      Dir.glob(File.dirname(__FILE__) + '/../app/components/**/*.rb').each do |file|
        require file
      end
    end
  end

  class Configuration
    attr_accessor :base_component_class

    def initialize
      @base_component_class = LocoMotion::BaseComponent
    end
  end
end
