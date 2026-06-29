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
    # `middle_icon:` options, picking up an accompanying `library:` /
    # `icon_library:` and `variant:` / `icon_variant:` on the same line.
    #
    # Like Tailwind, it cannot see dynamically-built names
    # (`loco_icon("bars-#{n}")`, `icon: some_var`) — those belong in
    # {LocoMotion::Configuration#icon_safelist}.
    #
    class Scanner
      # The icon name in a `loco_icon("foo")` / `hero_icon "foo"` call.
      HELPER = /\b(?:loco_icon|hero_icon)\s*\(?\s*(["'])([a-z0-9][a-z0-9-]*)\1/

      # A name passed via icon:/left_icon:/right_icon:/middle_icon: (also covers
      # `loco_icon(icon: "foo")`). Longest keys first so `icon` does not win
      # inside `left_icon`.
      KWARG = /\b(?:left_icon|right_icon|middle_icon|icon)\s*:\s*(["'])([a-z0-9][a-z0-9-]*)\1/

      # An accompanying library / variant on the same line. Matches both the
      # `loco_icon` forms (`library:` / `variant:`) and the component options
      # (`icon_library:` / `left_icon_variant:` / ...).
      LIBRARY = /\b(?:icon_library|left_icon_library|right_icon_library|library)\s*:\s*[:"']?([a-z0-9_]+)/
      VARIANT = /\b(?:icon_variant|left_icon_variant|right_icon_variant|variant)\s*:\s*[:"']?([a-z0-9_]+)/

      #
      # Parses {LocoMotion::Configuration#icon_safelist} entries into the same
      # reference shape {#references} returns. Each entry is `"name"`,
      # `"library:name"`, or `"library:name:variant"`.
      #
      # @param entries [Array<String>] The safelist entries.
      #
      # @param default_library [String, Symbol] Library for `"name"` entries.
      #
      # @return [Array<Hash>] `{ library:, variant:, name: }` references.
      #
      def self.parse_safelist(entries, default_library:)
        Array(entries).map do |entry|
          parts = entry.to_s.split(":")
          case parts.length
          when 1 then { library: default_library.to_s, variant: nil, name: parts[0] }
          when 2 then { library: parts[0], variant: nil, name: parts[1] }
          else { library: parts[0], variant: parts[2], name: parts[1] }
          end
        end
      end

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
        names = line.scan(HELPER).map(&:last) + line.scan(KWARG).map(&:last)
        return [] if names.empty?

        library = line[LIBRARY, 1] || @default_library
        variant = line[VARIANT, 1]
        variant = nil if variant == "nil"

        names.uniq.map { |name| { library: library, variant: variant, name: name } }
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
