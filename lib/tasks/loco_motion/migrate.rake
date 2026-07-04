# frozen_string_literal: true

namespace :loco_motion do
  namespace :migrate do
    desc "Rewrite the start/end component API removed in v0.7.0 " \
         "(with_start / with_end, start: / end:, start_css: / end_html: / ...) " \
         "to leading/trailing across the labelable inputs, navbars, timeline " \
         "events, and modal action slots. Dry-run by default; pass [apply] or " \
         "APPLY=1 to write changes. PATHS=app,lib overrides the scanned " \
         "directories."
    task :leading_trailing, [:mode] => :environment do |_task, args|
      apply = args[:mode].to_s == "apply" || ENV["APPLY"].to_s != ""
      paths = if ENV["PATHS"].to_s == ""
                LocoMotion::Migrations::LeadingTrailing::DEFAULT_PATHS
              else
                ENV["PATHS"].split(",").map { |dir| "#{dir.strip}/**/*.{rb,erb,haml,slim}" }
              end

      migration = LocoMotion::Migrations::LeadingTrailing.new(
        root: Rails.root.to_s,
        paths: paths,
        apply: apply
      ).run

      migration.changes.group_by { |change| change[:file] }.each do |file, changes|
        puts "#{file}:"
        changes.each do |change|
          puts "  #{change[:line]}:"
          puts "  - #{change[:before].strip}"
          puts "  + #{change[:after].strip}"
        end
        puts
      end

      unless migration.leftovers.empty?
        puts "Needs manual review (LocoMotion components all use leading/trailing"
        puts "now, but a custom component's own start/end slots should stay):"
        migration.leftovers.each do |leftover|
          puts "  #{leftover[:file]}:#{leftover[:line]}: #{leftover[:text]}"
        end
        puts
      end

      if migration.changes.empty?
        puts "✓ Nothing to migrate."
      elsif apply
        puts "✓ Rewrote #{migration.changes.size} lines across " \
             "#{migration.changes.map { |c| c[:file] }.uniq.size} files."
      else
        puts "Dry run: #{migration.changes.size} lines across " \
             "#{migration.changes.map { |c| c[:file] }.uniq.size} files would change."
        puts "Re-run with APPLY=1 (or [apply]) to write the changes."
      end
    end
  end
end
