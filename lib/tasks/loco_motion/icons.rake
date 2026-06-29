# frozen_string_literal: true

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

    desc "Treeshake vendored icons: scan content paths + safelist and vendor " \
         "only the icons you use (loco_motion:icons:sync)"
    task sync: :environment do
      require "tmpdir"

      config = LocoMotion.configuration
      root = Rails.root.to_s
      target = Rails.root.join("app/assets/svg/icons").to_s

      references = LocoMotion::Icons::Scanner.new(
        paths: config.icon_content_paths,
        root: root,
        default_library: config.default_icon_library
      ).references

      references += LocoMotion::Icons::Scanner.parse_safelist(
        config.icon_safelist, default_library: config.default_icon_library
      )
      references.uniq!

      if references.empty?
        puts "No icon references found in #{config.icon_content_paths.join(', ')}."
        next
      end

      libraries = references.map { |ref| ref[:library] }.uniq.sort

      Dir.mktmpdir do |tmp|
        LocoMotion::Icons::Installer.add(libraries, target: tmp)

        result = LocoMotion::Icons::Vendorer.new(
          source: tmp,
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

      curated = %w[x-mark check trash]
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
