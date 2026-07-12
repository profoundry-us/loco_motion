# frozen_string_literal: true

module LocoMotion
  module Icons
    #
    # Checks that every icon reference resolves from the given icon roots —
    # typically the application's vendored `app/assets/svg/icons` plus the
    # engine's bundled set, deliberately excluding the development-only local
    # cache the {LocoMotion::Icons::Renderer} may fall back to. That makes it
    # the treeshake's audit step: `loco_motion:icons:verify` uses it to fail
    # loudly when a referenced icon has not been vendored, no matter which
    # environment the app happens to be running in.
    #
    # Like {LocoMotion::Icons::Vendorer}, it is pure file I/O and mirrors the
    # renderer's path resolution — `<library>/<variant>/<name>.svg`, with a
    # `nil` variant (flat library) collapsing to `<library>/<name>.svg`.
    #
    class Verifier
      Result = ::Struct.new(:verified, :missing, keyword_init: true)

      #
      # @param roots [Array<String>] Icon root directories to resolve
      #   against, in the renderer's precedence order (the application's
      #   vendored set, then the engine's bundled set).
      #
      # @param default_variant [String, Symbol, nil] Variant used for
      #   references that do not specify one (mirrors the renderer's
      #   default).
      #
      def initialize(roots:, default_variant:)
        @roots = Array(roots).map(&:to_s)
        @default_variant = default_variant
      end

      #
      # @param references [Array<Hash>] `{ library:, variant:, name: }`
      #   entries, as produced by {LocoMotion::Icons::Scanner} /
      #   {LocoMotion::Icons::Reference}.
      #
      # @return [Result] The count of references that resolved and the
      #   references that resolved from none of the roots.
      #
      def verify(references)
        missing = references.reject { |ref| resolves?(ref) }

        Result.new(verified: references.size - missing.size, missing: missing)
      end

      private

      def resolves?(ref)
        @roots.any? { |root| ::File.file?(::File.join(root, *parts(ref))) }
      end

      # Mirrors LocoMotion::Icons::Renderer path resolution: a `nil` variant
      # (flat library) collapses to `<library>/<name>.svg`.
      def parts(ref)
        variant = ref[:variant] || @default_variant
        [ref[:library], variant&.to_s, "#{ref[:name]}.svg"].compact.reject(&:empty?)
      end
    end
  end
end
