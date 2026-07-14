# frozen_string_literal: true

module LocoMotion
  module Migrations
    #
    # Rewrites the `start` / `end` component API (removed in v0.7.0) to its
    # `leading` / `trailing` replacement — `with_start` / `with_end` slot
    # calls (and the Modal's `with_start_actions` / `with_end_actions`),
    # `start:` / `end:` keyword arguments, and the generated part options
    # (`start_css:`, `end_html:`, `start_actions_css:`, ...) on every renamed
    # call: the labelable helpers (`daisy_text_input`, `daisy_input`,
    # `daisy_select`, `daisy_checkbox`, `daisy_toggle`, `daisy_radio`,
    # `daisy_cally_input`), the ThemeController's `build_radio_input`,
    # `daisy_navbar`, `daisy_modal`, and the timeline's `with_event`.
    #
    # This is intentionally NOT a blind find-and-replace: an app's own
    # components may define `start` / `end` slots of their own. So keyword
    # arguments are renamed only inside a recognized call, and
    # `with_start` / `with_end` only when called on the block variable of an
    # enclosing recognized block. Anything the scan cannot confidently
    # attribute is collected in {#leftovers} for manual review instead of
    # rewritten.
    #
    # Like the icons Scanner, this is a plain line-based rewrite with no Ruby
    # evaluation, so the same source always produces the same result. It runs
    # as a dry run unless `apply:` is true.
    #
    class LeadingTrailing
      # The file set scanned by default, relative to `root`.
      DEFAULT_PATHS = ["app/**/*.{rb,erb,haml,slim}"].freeze

      # Helpers and builders whose calls take the renamed options and whose
      # blocks yield a component with `leading` / `trailing` slots.
      HELPERS = %w[
        daisy_text_input daisy_input daisy_select daisy_checkbox
        daisy_toggle daisy_radio daisy_cally_input build_radio_input
        daisy_navbar daisy_modal with_event
      ].freeze

      # Matches a call to any of the helpers above.
      HELPER_CALL = /\b(?:#{HELPERS.join('|')})\b/

      # Maps each removed option/slot name to its replacement.
      RENAMES = { "start" => "leading", "end" => "trailing" }.freeze

      # `start:` / `end:` (plus the Modal's `_actions` pair and the generated
      # part options) as keyword arguments. The leading `(`, `,`, `{`, or
      # start-of-line guard keeps words inside strings (`"checkbox_end"`) and
      # other symbols (`:start_date`) from matching.
      KWARG = /(^\s*|[(,{]\s*)(start|end)(_actions)?(_css|_html|_aria|_data)?:(?!:)/

      # The same keys written with a hash rocket (`:end => "..."`).
      KWARG_ROCKET = /(^\s*|[(,{]\s*):(start|end)(_actions)?(_css|_html|_aria|_data)?(\s*=>)/

      # A `do |var|` / `{ |var|` block parameter on the final line of a call.
      BLOCK_PARAM = /(?:\bdo|\{)\s*\|\s*(\w+)\s*\|/

      #
      # @param root [String] The directory the path globs resolve against
      #   (usually `Rails.root`).
      #
      # @param paths [Array<String>] Glob patterns to scan, relative to root.
      #
      # @param apply [Boolean] When true, write the rewritten files back to
      #   disk. When false (the default), only compute {#changes}.
      #
      def initialize(root:, paths: DEFAULT_PATHS, apply: false)
        @root = root.to_s
        @paths = Array(paths)
        @apply = apply
        @changes = []
        @leftovers = []
      end

      #
      # @return [Array<Hash>] One entry per rewritten line:
      #   `{ file:, line:, before:, after: }` (line numbers are 1-based and
      #   files are relative to root).
      attr_reader :changes

      #
      # @return [Array<Hash>] Occurrences that were left untouched for manual
      #   review: `{ file:, line:, text:, reason: }`.
      attr_reader :leftovers

      #
      # @return [Boolean] Whether {#run} writes files or only reports.
      def apply?
        @apply
      end

      #
      # Scans (and, in apply mode, rewrites) every matched file.
      #
      # @return [LocoMotion::Migrations::LeadingTrailing] self, so callers can
      #   chain `migration.run.changes`.
      #
      def run
        files.each { |file| process_file(file) }

        self
      end

      private

      def files
        @paths.flat_map { |pattern| Dir.glob(::File.join(@root, pattern)) }
              .select { |path| ::File.file?(path) }
              .uniq
              .sort
      end

      def process_file(path)
        lines = ::File.readlines(path, encoding: "UTF-8")
        relative = relative_path(path)

        new_lines = rewrite_lines(lines, relative)
        collect_leftovers(new_lines, relative)

        return if new_lines == lines

        ::File.write(path, new_lines.join) if apply?
      end

      #
      # Walks the file line by line, tracking two pieces of state: the current
      # helper-call span (a call's argument list, which may continue across
      # lines via open parentheses or a trailing comma) and the stack of open
      # labelable blocks (so `var.with_start` is renamed only for variables a
      # labelable call yielded).
      #
      def rewrite_lines(lines, relative)
        open_blocks = []
        span = nil

        lines.each_with_index.map do |line, index|
          indent = line[/\A */].size
          close_finished_blocks(open_blocks, line, indent)

          span ||= begin_span(line, indent)
          new_line = span ? rename_kwargs(line) : line
          new_line = rename_slots(new_line, open_blocks)
          span = continue_span(span, line, open_blocks)

          record_change(relative, index, line, new_line)
          new_line
        end
      end

      # A block is closed by the first non-blank line at or above the
      # indentation of the line that opened it.
      def close_finished_blocks(open_blocks, line, indent)
        return if line.strip.empty?

        open_blocks.reject! { |block| indent <= block[:indent] }
      end

      # Starts a span when the line calls a labelable helper. `depth` tracks
      # parenthesis balance for `helper(...)` calls; `nil` depth means a
      # paren-less call that continues only while lines end with a comma.
      def begin_span(line, indent)
        match = line.match(HELPER_CALL)
        return nil unless match

        span = { indent: indent, depth: nil }
        rest = match.post_match

        span[:depth] = rest.count("(") - rest.count(")") if rest =~ /\A\s*\(/

        span
      end

      #
      # Decides whether the call's argument list continues on the next line.
      # When the span ends, a trailing `do |var|` / `{ |var|` opens a
      # labelable block scoped to the helper line's indentation.
      #
      def continue_span(span, line, open_blocks)
        return nil unless span

        if span[:depth]
          # Subsequent lines adjust the balance counted by begin_span.
          span[:depth] += line.count("(") - line.count(")") unless line =~ HELPER_CALL
          return span if span[:depth].positive?
        elsif line.rstrip.end_with?(",")
          return span
        end

        if (match = line.match(BLOCK_PARAM))
          open_blocks << { var: match[1], indent: span[:indent] }
        end

        nil
      end

      def rename_kwargs(line)
        renamed = line.gsub(KWARG) do
          "#{::Regexp.last_match(1)}#{RENAMES[::Regexp.last_match(2)]}" \
            "#{::Regexp.last_match(3)}#{::Regexp.last_match(4)}:"
        end

        renamed.gsub(KWARG_ROCKET) do
          "#{::Regexp.last_match(1)}:#{RENAMES[::Regexp.last_match(2)]}" \
            "#{::Regexp.last_match(3)}#{::Regexp.last_match(4)}#{::Regexp.last_match(5)}"
        end
      end

      def rename_slots(line, open_blocks)
        open_blocks.reduce(line) do |result, block|
          result.gsub(/\b#{::Regexp.escape(block[:var])}\.with_(start|end)(_actions)?\b/) do
            "#{block[:var]}.with_#{RENAMES[::Regexp.last_match(1)]}#{::Regexp.last_match(2)}"
          end
        end
      end

      def record_change(relative, index, before, after)
        return if before == after

        @changes << {
          file: relative,
          line: index + 1,
          before: before.chomp,
          after: after.chomp
        }
      end

      #
      # Anything still carrying the old names after the rewrite gets flagged
      # rather than guessed at — `with_start` / `with_end` on a receiver we
      # could not attribute (which may be a custom component whose own
      # `start` / `end` slots should stay), or recognized-call kwargs the
      # span scan could not safely rewrite.
      #
      def collect_leftovers(lines, relative)
        lines.each_with_index do |line, index|
          if line =~ /\.\s*with_(?:start|end)(?:_actions)?\b/
            add_leftover(relative, index, line,
                         "could not trace the receiver to a renamed component's block — rename " \
                         "manually if it is one; a custom component's own start/end slots should stay")
          elsif line =~ HELPER_CALL && (line =~ KWARG || line =~ KWARG_ROCKET)
            add_leftover(relative, index, line,
                         "recognized call still passing start/end options — rename manually")
          end
        end
      end

      def add_leftover(relative, index, line, reason)
        @leftovers << {
          file: relative,
          line: index + 1,
          text: line.strip,
          reason: reason
        }
      end

      def relative_path(path)
        path.start_with?("#{@root}/") ? path.delete_prefix("#{@root}/") : path
      end
    end
  end
end
