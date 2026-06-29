# frozen_string_literal: true

namespace :loco_motion do
  namespace :icons do
    desc "Regenerate the Heroicons SVGs bundled inside the engine (from the " \
         "upstream Heroicons repo via the icons gem). Maintainer task."
    task :vendor_heroicons do
      require "icons"
      require "fileutils"

      engine_root = LocoMotion::Engine.root
      target = engine_root.join("app/assets/svg/icons")

      Icons.configure { |config| config.icons_path = target.to_s }

      FileUtils.rm_rf(target.join("heroicons"))
      puts "Syncing Heroicons into #{target.join('heroicons')} ..."
      Icons::Sync.new("heroicons").now

      # The icons gem clones into a `tmp/icons` working directory; clean it up.
      FileUtils.rm_rf(engine_root.join("tmp/icons"))
      FileUtils.rm_rf("tmp/icons")

      count = Dir.glob(target.join("heroicons/**/*.svg")).count
      puts "✓ Vendored #{count} Heroicon SVGs"
    end
  end
end
