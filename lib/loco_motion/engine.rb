module LocoMotion
  class Engine < ::Rails::Engine
    isolate_namespace LocoMotion

    config.autoload_paths << "#{root}/app"
    config.autoload_paths << "#{root}/lib"
  end
end
