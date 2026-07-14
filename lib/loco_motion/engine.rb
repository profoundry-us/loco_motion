# frozen_string_literal: true

module LocoMotion
  #
  # Standard Rails::Engine that mounts LocoMotion's app/lib autoload paths
  # into the host application and wires up its Action View helper
  # extensions.
  #
  class Engine < ::Rails::Engine
    isolate_namespace LocoMotion

    config.autoload_paths << "#{root}/app"
    config.autoload_paths << "#{root}/lib"

    initializer "loco_motion.form_builder_extensions" do
      ActiveSupport.on_load(:action_view) do
        require_relative "../../app/helpers/daisy/form_builder_helper"
      end
    end

    initializer "loco_motion.theme_helper" do
      ActiveSupport.on_load(:action_view) do
        require_relative "../../app/helpers/daisy/theme_helper"
      end
    end
  end
end
