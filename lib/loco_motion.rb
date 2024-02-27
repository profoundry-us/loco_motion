require "view_component"
require "loco_motion/engine"
require "loco_motion/base_component"

module LocoMotion
  class << self
    def hello_world
      "Hello world!"
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :base_component_class

    def initialize
      @base_component_class = LocoMotion::BaseComponent
    end
  end
end
