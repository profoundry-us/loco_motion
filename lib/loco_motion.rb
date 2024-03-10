require "rails"
require "view_component"
require "loco_motion/engine"
require "loco_motion/errors"
require "loco_motion/component_config"
require "loco_motion/base_component"

module LocoMotion
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
