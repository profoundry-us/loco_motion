# frozen_string_literal: true

module LocoMotion
  class << self
    #
    # Yields the current {Configuration} instance so it can be customized,
    # typically from an initializer.
    #
    # @return [void]
    #
    def configure
      yield(configuration)
    end

    #
    # Return the current instance of the LocoMotion::Configuration or create a
    # new one.
    #
    def configuration
      @configuration ||= Configuration.new
    end

    #
    # Mostly used for internal testing; not needed in Rails
    #
    def require_components
      comp_files = Dir.glob("#{File.dirname(__FILE__)}/../../app/components/**/*.rb")

      comp_files.each do |file|
        require file
      end
    end
  end

  #
  # Configuration class for LocoMotion. Allows developers to customize
  # default behavior across their application.
  #
  # @example Configure LocoMotion with custom settings
  #   LocoMotion.configure do |config|
  #     config.default_alert_timeout = 10000
  #   end
  #
  class Configuration
    #
    # The default timeout (in milliseconds) for auto-dismissing alerts.
    # This value is used when an Alert component has a timeout set but no
    # explicit value is provided. The default is 5000ms (5 seconds).
    #
    # @return [Integer] The default timeout in milliseconds
    #
    attr_accessor :default_alert_timeout

    #
    # The default icon library used by the `loco_icon` helper (and the
    # universal `icon:` options) when no `library:` is given. Defaults to
    # `:heroicons`. Set this to make another synced library your default, e.g.
    # `config.default_icon_library = :lucide`.
    #
    # @return [String, Symbol] The default icon library
    #
    attr_accessor :default_icon_library

    #
    # The default icon variant used when no `variant:` is given. Defaults to
    # `:outline` (Heroicons' outline style). When changing
    # {#default_icon_library} to a library with different variants, set this to
    # match (or `nil` for a flat library that has no variant subdirectories).
    #
    # @return [String, Symbol, nil] The default icon variant
    #
    attr_accessor :default_icon_variant

    #
    # Glob patterns (relative to the application root) that
    # `loco_motion:icons:sync` scans for icon references when treeshaking the
    # vendored icon set — the icon analogue of Tailwind's `content` paths. Only
    # icons referenced in these files (plus {#icon_safelist}) are vendored.
    #
    # @return [Array<String>] The content glob patterns to scan
    #
    attr_accessor :icon_content_paths

    #
    # Icon references that `loco_motion:icons:sync` must always vendor, even
    # when no static usage is found — the icon analogue of Tailwind's
    # `safelist`. Use it for dynamically-named icons the scanner cannot see
    # (e.g. `loco_icon("bars-#{n}")` or a name pulled from a database).
    #
    # Each entry is a qualified `[library:]name[/variant]` token (see
    # {LocoMotion::Icons::Reference}), e.g. `"information-circle"`,
    # `"lucide:heart"`, `"bolt/solid"`, or `"phosphor:gear/bold"`. An omitted
    # library / variant falls back to {#default_icon_library} /
    # {#default_icon_variant}.
    #
    # @return [Array<String>] The safelisted icon references
    #
    attr_accessor :icon_safelist

    #
    # Where `loco_motion:icons:cache` stores the **full** icon libraries it
    # downloads, and where `loco_motion:icons:sync` copies from when
    # treeshaking. Resolved relative to the application root; the default lives
    # under `tmp/` (which Rails already gitignores) so the full set stays on
    # your machine while only the used icons are vendored into
    # `app/assets/svg/icons` and committed.
    #
    # @return [String] The local icon cache path
    #
    attr_accessor :icon_cache_path

    #
    # Whether the icon renderer may fall back to the full local cache
    # ({#icon_cache_path}) in development when an icon is missing from the
    # vendored `app/assets/svg/icons` set. Defaults to `true`, which keeps the
    # development loop fast: a freshly-referenced icon renders on the next
    # refresh without re-running `loco_motion:icons:sync`.
    #
    # Set this to `false` to resolve icons strictly from the vendored set in
    # every environment — a used-but-unvendored icon then fails loudly in
    # development and local test runs instead of surfacing for the first time
    # in production or CI.
    #
    # @return [Boolean] Whether the development cache fallback is enabled
    #
    attr_accessor :icon_dev_fallback

    def initialize
      @default_alert_timeout = 5000 # 5 seconds default
      @default_icon_library = :heroicons
      @default_icon_variant = :outline
      @icon_content_paths = ["app/**/*.{rb,erb,haml,slim}"]
      @icon_safelist = []
      @icon_cache_path = "tmp/loco_motion/icons"
      @icon_dev_fallback = true
    end
  end
end
