# frozen_string_literal: true

require "fileutils"

module LocoMotion
  module Icons
    #
    # Copies a treeshaken set of icons from a fully-synced source tree into the
    # application's vendored `app/assets/svg/icons`, given the references found
    # by {LocoMotion::Icons::Scanner} (plus any safelist).
    #
    # It is pure file I/O — the caller is responsible for first populating
    # `source` with the full upstream libraries (e.g. via
    # {LocoMotion::Icons::Installer}); keeping the network step out of here
    # makes the copy/prune logic deterministic and unit-testable.
    #
    # Each referenced library directory under `target` is rebuilt from scratch,
    # so icons that are no longer referenced are pruned. Libraries that are not
    # referenced at all are left untouched.
    #
    class Vendorer
      Result = ::Struct.new(:vendored, :missing, :libraries, keyword_init: true)

      #
      # @param source [String] Directory holding full libraries laid out as
      #   `<library>/<variant>/<name>.svg`.
      #
      # @param target [String] The application's `app/assets/svg/icons`.
      #
      # @param default_variant [String, Symbol, nil] Variant used for
      #   references that do not specify one (mirrors the renderer's default).
      #
      def initialize(source:, target:, default_variant:)
        @source = source.to_s
        @target = target.to_s
        @default_variant = default_variant
      end

      #
      # @param references [Array<Hash>] `{ library:, variant:, name: }` entries.
      #
      # @return [Result] Counts of vendored icons, the references whose source
      #   SVG was missing, and the libraries that were rebuilt.
      #
      def vendor(references)
        libraries = references.map { |ref| ref[:library] }.uniq.sort

        libraries.each { |library| ::FileUtils.rm_rf(::File.join(@target, library)) }

        vendored = 0
        missing = []

        references.each do |ref|
          if copy(ref)
            vendored += 1
          else
            missing << ref
          end
        end

        Result.new(vendored: vendored, missing: missing, libraries: libraries)
      end

      private

      def copy(ref)
        from = ::File.join(@source, *parts(ref))
        return false unless ::File.file?(from)

        to = ::File.join(@target, *parts(ref))
        ::FileUtils.mkdir_p(::File.dirname(to))
        ::FileUtils.cp(from, to)
        true
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
