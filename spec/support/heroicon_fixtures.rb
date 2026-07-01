# frozen_string_literal: true

require "fileutils"

# Seeds the Heroicons that component specs reference into the (ephemeral,
# gitignored) Combustion test app, so they resolve through the `loco_icon`
# engine exactly as they would in a consumer app that has synced them.
#
# Components render their managed icons via the engine, which reads from
# `<Rails.root>/app/assets/svg/icons`. The engine bundles a handful of chrome
# icons (check, chevron-left/right, trash, x-mark); every other name a spec
# uses must be present here. Add to the list below when a new spec references
# an icon the engine does not already bundle.
module HeroiconFixtures
  # variant => [icon names]
  ICONS = {
    "outline" => %w[
      academic-cap arrow-left arrow-right bars-3 chart-bar check-circle heart
      home information-circle link plus rocket-launch sparkles star swatch user
      user-circle
    ],
    "solid" => %w[home],
    "mini" => %w[home document cube squares-2x2]
  }.freeze

  STUB = %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" ) +
         %(fill="none" data-source="heroicons-fixture"><path d="M0 0"/></svg>)

  module_function

  def seed!
    root = ::Rails.root.join("app/assets/svg/icons/heroicons")

    ICONS.each do |variant, names|
      dir = root.join(variant)
      ::FileUtils.mkdir_p(dir)
      names.each { |name| ::File.write(dir.join("#{name}.svg"), STUB) }
    end
  end
end
