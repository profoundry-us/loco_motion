# frozen_string_literal: true

module LocoMotion
  module Icons
    #
    # Syncs icon libraries into a target directory (a host application's
    # `app/assets/svg/icons` by default) using the `icons` gem. Backs both the
    # `loco_motion:install` generator and the `loco_motion:icons:add` rake task.
    #
    # The sync clones each library from its upstream repository (git is required
    # at install time only); the resulting SVGs are then committed to the host
    # app and read directly from disk at render time.
    #
    module Installer
      module_function

      #
      # @param libraries [String, Symbol, Array] One or more library names
      #   (e.g. `"heroicons"`, `%w[lucide phosphor]`).
      #
      # @param target [String] Absolute path to the icons directory the SVGs
      #   should be synced into.
      #
      # @return [Array<String>] The library names that were synced.
      #
      def add(libraries, target:)
        require "icons"
        require "fileutils"

        names = Array(libraries).map(&:to_s).reject(&:empty?)
        ::FileUtils.mkdir_p(target)

        ::Icons.configure { |config| config.icons_path = target }
        names.each do |library|
          # Clear any existing copy first. The `icons` gem moves the freshly
          # cloned set into `<target>/<library>`, and that move silently no-ops
          # when the directory already exists — so without this, re-syncing a
          # library (to update it, or to refresh the cache) does nothing.
          ::FileUtils.rm_rf(::File.join(target, library))
          ::Icons::Sync.new(library).now
        end

        # The icons gem clones into a `tmp/icons` working directory; clean it up.
        ::FileUtils.rm_rf("tmp/icons")

        names
      end
    end
  end
end
