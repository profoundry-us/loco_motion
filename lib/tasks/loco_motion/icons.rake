# frozen_string_literal: true

# Scans the app (config.icon_content_paths) plus the safelist for icon
# references — shared by the :cache and :sync tasks below.
def build_icon_references(config)
  references = LocoMotion::Icons::Scanner.new(
    paths: config.icon_content_paths,
    root: Rails.root.to_s,
    default_library: config.default_icon_library
  ).references

  safelisted = Array(config.icon_safelist).map do |entry|
    LocoMotion::Icons::Reference.parse(entry, default_library: config.default_icon_library)
  end

  (references + safelisted).uniq
end

namespace :loco_motion do
  namespace :icons do
    # Libraries the icons gem knows how to sync (shown by `:list`).
    SUGGESTED_ICON_LIBRARIES = %w[
      heroicons lucide phosphor tabler boxicons feather
      hugeicons radix flags weather
    ].freeze

    desc "Sync icon libraries into this app's app/assets/svg/icons " \
         "(e.g. rake loco_motion:icons:add[lucide])"
    task :add, [:library] => :environment do |_task, args|
      libraries = [args[:library], *args.extras].compact.reject(&:empty?)
      libraries = ["heroicons"] if libraries.empty?

      target = Rails.root.join("app/assets/svg/icons").to_s
      synced = LocoMotion::Icons::Installer.add(libraries, target: target)

      puts "✓ Synced #{synced.join(', ')} into app/assets/svg/icons"
      puts "  Commit the new SVGs to your repository."
    end

    desc "Download full icon libraries into the local cache " \
         "(config.icon_cache_path) for fast, offline treeshaking with " \
         "loco_motion:icons:sync. With no args, caches every referenced library."
    task :cache, [:library] => :environment do |_task, args|
      config = LocoMotion.configuration
      cache = Rails.root.join(config.icon_cache_path).to_s

      libraries = [args[:library], *args.extras].compact.reject(&:empty?)
      libraries = build_icon_references(config).map { |ref| ref[:library] }.uniq if libraries.empty?
      libraries = libraries.compact.sort

      if libraries.empty?
        puts "No icon libraries referenced; nothing to cache."
        next
      end

      LocoMotion::Icons::Installer.add(libraries, target: cache)
      puts "✓ Cached #{libraries.join(', ')} in #{config.icon_cache_path}"
      puts "  This cache is local (gitignored). Run loco_motion:icons:sync to " \
           "vendor only the icons you use."
    end

    desc "Treeshake vendored icons: scan content paths + safelist and vendor " \
         "only the icons you use, copying from the local cache (loco_motion:icons:sync)"
    task sync: :environment do
      config = LocoMotion.configuration
      cache = Rails.root.join(config.icon_cache_path).to_s
      target = Rails.root.join("app/assets/svg/icons").to_s

      references = build_icon_references(config)

      if references.empty?
        puts "No icon references found in #{config.icon_content_paths.join(', ')}."
        next
      end

      libraries = references.map { |ref| ref[:library] }.uniq.sort

      # Pull any referenced library that isn't cached yet so the first run (or a
      # newly-used library) still works; already-cached libraries are reused, so
      # repeat runs are a fast, offline file copy.
      uncached = libraries.reject { |library| Dir.exist?(File.join(cache, library)) }
      unless uncached.empty?
        puts "Caching #{uncached.join(', ')} (not found in #{config.icon_cache_path})..."
        LocoMotion::Icons::Installer.add(uncached, target: cache)
      end

      result = LocoMotion::Icons::Vendorer.new(
        source: cache,
        target: target,
        default_variant: config.default_icon_variant
      ).vendor(references)

      puts "✓ Vendored #{result.vendored} icon(s) from #{libraries.join(', ')} " \
           "into app/assets/svg/icons"
      puts "  Commit the vendored SVGs to your repository."

      unless result.missing.empty?
        puts "\n⚠ #{result.missing.size} referenced icon(s) were not found " \
             "(check the name, library, or variant):"
        result.missing.each do |ref|
          location = [ref[:library], ref[:variant], ref[:name]].compact.join("/")
          puts "  - #{location}"
        end
      end
    end

    desc "List icon libraries you can sync with loco_motion:icons:add"
    task :list do
      puts "Suggested icon libraries you can add (loco_motion:icons:add[name]):"
      SUGGESTED_ICON_LIBRARIES.each { |library| puts "  - #{library}" }
      puts "See https://github.com/Rails-Designer/icons for the full list."
    end

    desc "Regenerate the curated Heroicons bundled inside the engine " \
         "(maintainer task)"
    task :vendor_bundled do
      require "icons"
      require "fileutils"
      require "tmpdir"

      # Icons LocoMotion components render (or that its basic components
      # commonly need), bundled so they work with zero consumer sync.
      # NOTE: Keep the bundled-icon list in Loco::IconComponent's class docs
      # in sync when changing this set:
      #   - x-mark: Alert / Modal close
      #   - check / trash / swatch: ThemeController
      #   - chevron-left / chevron-right: Cally month nav
      #   - information-circle / check-circle / exclamation-triangle /
      #     exclamation-circle: standard Alert info / success / warning / error
      curated = %w[
        x-mark check check-circle trash swatch chevron-left chevron-right
        information-circle exclamation-triangle exclamation-circle
      ]
      engine_target = LocoMotion::Engine.root.join("app/assets/svg/icons/heroicons")

      Dir.mktmpdir do |tmp|
        Icons.configure { |config| config.icons_path = tmp }
        Icons::Sync.new("heroicons").now
        FileUtils.rm_rf("tmp/icons")

        FileUtils.rm_rf(engine_target)
        Dir.glob(File.join(tmp, "heroicons", "*")).each do |variant_dir|
          variant = File.basename(variant_dir)
          curated.each do |name|
            source = File.join(variant_dir, "#{name}.svg")
            next unless File.file?(source)

            dest_dir = engine_target.join(variant)
            FileUtils.mkdir_p(dest_dir)
            FileUtils.cp(source, dest_dir.join("#{name}.svg"))
          end
        end
      end

      count = Dir.glob(engine_target.join("**/*.svg")).count
      puts "✓ Vendored #{count} curated Heroicon SVGs (#{curated.join(', ')})"
    end
  end
end
