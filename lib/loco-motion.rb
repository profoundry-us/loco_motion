require "view_component"

module LocoMotion
  APP_PATH = File.expand_path(File.join(__dir__, "../app"))

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

  autoload :BaseComponent, "loco-motion/base_component"

  module Buttons
    autoload :ButtonComponent, File.join(LocoMotion::APP_PATH, "components/buttons/button_component.rb")
    autoload :FabComponent, File.join(LocoMotion::APP_PATH, "components/buttons/fab_component")
  end
end
