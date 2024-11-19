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
  # Unused for now. Was previously using to setup a base class for all
  # LocoMotion components to inherit from.
  #
  class Configuration
  end

end
