module LocoMotion

  class << self
    def configure
      yield(configuration)
    end

    #
    # Return the current instance of the LocoMotion::Configuration or create a
    # new one.
    #
    def configuration
      @configuration ||= Configuration.new
    end

    #
    # Mostly used for internal testing; not needed in Rails
    #
    def require_components
      comp_files = Dir.glob(File.dirname(__FILE__) + '/../../app/components/**/*.rb')

      comp_files.each do |file|
        require file
      end
    end
  end

  #
  # Configuration class for LocoMotion. Allows developers to customize
  # default behavior across their application.
  #
  class Configuration
    attr_accessor :default_alert_timeout

    def initialize
      @default_alert_timeout = 5000 # 5 seconds default
    end
  end

end
