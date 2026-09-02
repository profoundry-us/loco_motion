# frozen_string_literal: true

require "better_html"
require "better_html/parser"
require_relative "../component_map"

module ERBLint
  module Linters
    # The ERB counterpart of the haml_lint rule: flags views hand-rolling
    # DaisyUI markup instead of calling the LocoMotion helper that owns it —
    # `class="card"` where `daisy_card` belongs.
    #
    # Both linters read the SAME derived map ({LocoMotion::Lint::ComponentMap}),
    # so the two template languages cannot enforce different rules. That was the
    # practical failure of the hand-written list this replaces: it covered both
    # languages with one regex and drifted from the library in both at once.
    #
    # Consumers load this from a `.erb_linters/` shim — see the README.
    class LocoMotionComponentUsage < Linter
      include LinterRegistry

      def run(processed_source)
        each_class(processed_source) do |css_class, tag|
          helper = component_map[css_class]
          next unless helper

          add_offense(
            processed_source.to_source_range(tag.loc),
            "`#{css_class}` is LocoMotion's #{helper} — " \
            "call the helper instead of hand-rolling the markup"
          )
        end
      end

      private

      # Built once per process: deriving reads ~70 component sources, which
      # should not be paid per template.
      def component_map
        self.class.cached_map ||= LocoMotion::Lint::ComponentMap.build
      end

      class << self
        attr_accessor :cached_map
      end

      # Only static class attributes are read. `class="<%= foo %>"` is computed,
      # and guessing at it would produce the false positives that get a linter
      # switched off.
      def each_class(processed_source)
        processed_source.parser.nodes_with_type(:tag).each do |node|
          tag = BetterHtml::Tree::Tag.from_node(node)
          next if tag.closing?

          value = tag.attributes["class"]&.value
          next if value.nil? || value.empty?

          value.split(/\s+/).uniq.each { |css_class| yield(css_class, tag) }
        end
      end
    end
  end
end
