
#
# Module containing all features related to the LocoMotion gem.
#
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
      comp_files = Dir.glob(File.dirname(__FILE__) + '/../../app/components/**/*.rb')

      comp_files.each do |file|
        require file
      end
    end

    def define_render_helper(name, component)
    end
  end

  class Configuration
    attr_accessor :base_component_class

    def initialize
      @base_component_class = LocoMotion::BaseComponent
    end
  end

end
