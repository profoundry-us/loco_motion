module LocoMotion
  class Engine < ::Rails::Engine
    isolate_namespace LocoMotion

    config.autoload_paths << "#{root}/app"
    config.autoload_paths << "#{root}/lib"
    
    initializer "loco_motion.form_builder_extensions" do
      ActiveSupport.on_load(:action_view) do
        require_relative "../../app/helpers/daisy/form_builder_helper"
      end
    end
  end
end
