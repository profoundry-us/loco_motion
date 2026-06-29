# frozen_string_literal: true

module LocoMotion
  module Icons
    #
    # Scans application source for **static** icon references so
    # `loco_motion:icons:sync` can vendor only the icons actually used — the
    # icon analogue of Tailwind scanning your templates for class names.
    #
    # It is intentionally a plain regex scan (no Ruby evaluation), so it is
    # fully deterministic: the same source always yields the same set. It
    # recognizes the `loco_icon` / `hero_icon` helpers (first string argument or
    # `icon:`) and the universal `icon:` / `left_icon:` / `right_icon:` /
    # `middle_icon:` options. The icon's library and variant come from the
    # token itself — `[library:]name[/variant]` (see
    # {LocoMotion::Icons::Reference}) — so a reference is self-contained and the
    # scan never has to guess from other arguments that may be on another line.
    #
    # Like Tailwind, it cannot see dynamically-built names
    # (`loco_icon("bars-#{n}")`, `icon: some_var`) — those belong in
    # {LocoMotion::Configuration#icon_safelist}.
    #
    class Scanner
      # The qualified token in a `loco_icon("foo")` / `hero_icon "foo"` call.
      HELPER = %r{\b(?:loco_icon|hero_icon)\s*\(?\s*(["'])([a-z0-9][a-z0-9:/-]*)\1}

      # A token passed via icon:/left_icon:/right_icon:/middle_icon: (also covers
      # `loco_icon(icon: "foo")`). Longest keys first so `icon` does not win
      # inside `left_icon`.
      KWARG = %r{\b(?:left_icon|right_icon|middle_icon|icon)\s*:\s*(["'])([a-z0-9][a-z0-9:/-]*)\1}

      #
      # @param paths [Array<String>] Glob patterns to scan (relative to root).
      #
      # @param root [String] The base directory the globs resolve against.
      #
      # @param default_library [String, Symbol] Library for references that do
      #   not name one explicitly.
      #
      def initialize(paths:, root:, default_library:)
        @paths = Array(paths)
        @root = root.to_s
        @default_library = default_library.to_s
      end

      #
      # @return [Array<Hash>] Unique references, each
      #   `{ library:, variant:, name: }` (`variant` is `nil` when unspecified,
      #   meaning "the library's default"), sorted for stable output.
      #
      def references
        refs = {}

        files.each do |file|
          each_reference(file) { |ref| refs[ref] ||= ref }
        end

        refs.values.sort_by { |r| [r[:library], r[:variant].to_s, r[:name]] }
      end

      private

      def files
        @paths.flat_map { |pattern| Dir.glob(::File.join(@root, pattern)) }
              .select { |path| ::File.file?(path) }
              .uniq
              .sort
      end

      def each_reference(file, &block)
        comment = comment_prefix(file)

        ::File.foreach(file) do |line|
          next if line.lstrip.start_with?(comment)

          line_references(line).each(&block)
        end
      end

      def line_references(line)
        tokens = line.scan(HELPER).map(&:last) + line.scan(KWARG).map(&:last)

        tokens.uniq.map { |token| Reference.parse(token, default_library: @default_library) }
      end

      # Skip Ruby comment lines (which carry YARD `@loco_example` snippets) and
      # HAML/Slim comment lines. A leading `#` in HAML is an id selector, not a
      # comment, so only Ruby files skip `#`.
      def comment_prefix(file)
        ::File.extname(file) == ".rb" ? "#" : "-#"
      end
    end
  end
end
