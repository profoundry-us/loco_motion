# frozen_string_literal: true

require "nokogiri"

module LocoMotion
  module Icons
    #
    # Raised when an icon (or its library / variant) cannot be found on disk.
    #
    class IconNotFound < StandardError; end

    #
    # Renders an icon as inline SVG from a vendored or app-synced icon library.
    #
    # Resolution checks, in order: the consuming application's own
    # `<Rails.root>/app/assets/svg/icons` (so any library a consumer syncs in —
    # or an icon they override — wins); **in development only**, the local icon
    # cache (`config.icon_cache_path`) so a newly-used icon renders without
    # re-running `loco_motion:icons:sync`; then LocoMotion's bundled icons
    # shipped inside the engine. This lets the default Heroicons work with zero
    # setup while letting consumers add or override icons without touching the
    # gem. Test and production skip the cache, so the committed set stays the
    # source of truth.
    #
    # SVG files are parsed in **XML mode** so case-sensitive attributes like
    # `viewBox` (and `clipPath`, `linearGradient`, ...) keep their casing —
    # unlike HTML-mode parsing, which would lowercase them into invalid SVG.
    #
    class Renderer
      DEFAULT_LIBRARY = :heroicons
      DEFAULT_VARIANT = :outline

      #
      # @param name [String, Symbol] The icon name. May be a qualified token,
      #   `[library:]name[/variant]` (e.g. `"academic-cap"`, `"lucide:heart"`,
      #   `"phosphor:gear/bold"`); anything the token specifies overrides the
      #   `library:` / `variant:` arguments. See {LocoMotion::Icons::Reference}.
      #
      # @param library [String, Symbol] The icon library (default
      #   `:heroicons`).
      #
      # @param variant [String, Symbol, nil] The library variant / weight
      #   (e.g. `:outline`, `:solid`). `nil` means the library is flat (no
      #   variant subdirectory).
      #
      # @param attributes [Hash] HTML attributes to apply to the `<svg>` — the
      #   shape returned by `rendered_html` (`:class` string, `:data` /
      #   `:aria` hashes, plus any other attributes).
      #
      def initialize(name:, library: DEFAULT_LIBRARY, variant: DEFAULT_VARIANT, attributes: {})
        ref = Reference.parse(name, default_library: library || DEFAULT_LIBRARY, default_variant: variant)
        @name = ref[:name]
        @library = ref[:library].to_s
        @variant = ref[:variant]&.to_s
        @attributes = attributes || {}
      end

      #
      # @return [String] The inline SVG markup with our attributes applied.
      #
      def to_svg
        document = Nokogiri::XML(::File.read(file_path))
        svg = document.root
        apply_attributes(svg)
        svg.to_xml
      end

      private

      def file_path
        search_paths.each { |path| return path if ::File.file?(path) }

        raise IconNotFound, missing_message
      end

      # App-synced icons take precedence over the engine's bundled set.
      def search_paths
        icon_roots.map { |root| ::File.join(root, *path_parts) }
      end

      def icon_roots
        roots = []
        roots << ::File.join(application_root, "app/assets/svg/icons") if application_root
        roots << cache_root if cache_root
        roots << ::File.join(LocoMotion::Engine.root.to_s, "app/assets/svg/icons")
        roots
      end

      def application_root
        return unless defined?(::Rails) && ::Rails.respond_to?(:root) && ::Rails.root

        ::Rails.root.to_s
      end

      # In development only, fall back to the full local cache that
      # `loco_motion:icons:sync` treeshakes from, so a freshly-used icon renders
      # on the next refresh without re-running sync. The cache is dev-only
      # (gitignored, not deployed), so test and production resolve strictly from
      # the committed `app/assets/svg/icons` — which keeps the treeshaken set
      # honest: a used-but-unvendored icon fails loudly there instead of being
      # masked by the cache.
      def cache_root
        return unless application_root
        return unless defined?(::Rails) && ::Rails.respond_to?(:env) && ::Rails.env.development?

        ::File.expand_path(LocoMotion.configuration.icon_cache_path, application_root)
      end

      def path_parts
        [@library, @variant, "#{@name}.svg"].compact.reject(&:empty?)
      end

      def apply_attributes(svg)
        @attributes.each do |key, value|
          case key.to_sym
          when :class
            apply_class(svg, value)
          when :data, :aria
            apply_prefixed(svg, key, value)
          else
            svg[key.to_s.tr("_", "-")] = value.to_s unless value.nil?
          end
        end
      end

      def apply_class(svg, value)
        classes = [svg["class"], value].compact.map(&:to_s).reject(&:empty?)

        svg["class"] = classes.join(" ") unless classes.empty?
      end

      def apply_prefixed(svg, prefix, value)
        return unless value.is_a?(::Hash)

        value.each do |key, val|
          next if val.nil?

          svg["#{prefix}-#{key.to_s.tr('_', '-')}"] = val.to_s
        end
      end

      def missing_message
        looked = search_paths.map { |path| "  - #{path}" }.join("\n")
        variant_note = @variant ? " (variant: #{@variant})" : ""

        <<~MSG.strip
          Could not find icon "#{@name}" in library "#{@library}"#{variant_note}.
          Looked in:
          #{looked}
          If "#{@library}" is not bundled with LocoMotion, add it with:
            bin/rails loco_motion:icons:add #{@library}
        MSG
      end
    end
  end
end
