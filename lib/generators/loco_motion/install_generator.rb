# frozen_string_literal: true

require "rails/generators/base"

module LocoMotion
  module Generators
    #
    # Installs LocoMotion's default icon set (Heroicons) into the host
    # application by syncing the SVGs into `app/assets/svg/icons`, where the
    # `loco_icon` helper resolves them. Run this once as part of setup:
    #
    #   bin/rails generate loco_motion:install
    #
    # Pass library names to install others at the same time:
    #
    #   bin/rails generate loco_motion:install lucide phosphor
    #
    class InstallGenerator < ::Rails::Generators::Base
      desc "Sync LocoMotion icon libraries into app/assets/svg/icons " \
           "(Heroicons by default)."

      argument :libraries, type: :array, default: ["heroicons"],
                           banner: "library library"

      def sync_icons
        target = ::File.join(destination_root, "app/assets/svg/icons")

        say "Syncing #{libraries.join(', ')} into app/assets/svg/icons ...", :green
        LocoMotion::Icons::Installer.add(libraries, target: target)
        say "✓ Synced #{libraries.join(', ')}. Commit the SVGs to your repo.", :green
      end
    end
  end
end
