# frozen_string_literal: true

require_relative "../component_map"

module HamlLint
  # Flags views that hand-roll DaisyUI component markup instead of calling the
  # LocoMotion helper that owns it — `.card` where `daisy_card` belongs.
  #
  # The class list is DERIVED from the component registry at load time (see
  # {LocoMotion::Lint::ComponentMap}), so it cannot fall behind the library the
  # way a hand-maintained list does. The list this replaces covered 25 of 70
  # components; every component added since it was written was unenforced.
  #
  # Views compose components; components own markup. LocoMotion's own component
  # templates are therefore the one place raw DaisyUI classes belong, and should
  # be excluded in .haml-lint.yml.
  #
  # Tailwind utilities (flex, p-4, hover:*) are never flagged — utilities in a
  # view are correct usage.
  class Linter::LocoMotionComponentUsage < Linter
    include LinterRegistry

    STATIC_TYPES = %i[str sym].freeze

    def visit_tag(node)
      classes = node.static_classes.flatten + hash_classes(node)

      classes.uniq.each do |css_class|
        helper = component_map[css_class]
        next unless helper

        record_lint(node, "`.#{css_class}` is LocoMotion's #{helper} — " \
                          "call the helper instead of hand-rolling the markup")
      end
    end

    private

    # Built once per process, not per file: 70 component sources are read to
    # derive it (~8ms), which should not be paid per template.
    def component_map
      @component_map ||= (self.class.cached_map ||= LocoMotion::Lint::ComponentMap.build)
    end

    class << self
      attr_accessor :cached_map
    end

    # `%div{ class: "card" }` — the attributes-hash spelling. Only static string
    # values are read; a computed class is not ours to judge.
    def hash_classes(node)
      node.dynamic_attributes_sources.flat_map do |code|
        source = code.start_with?("{") && code.end_with?("}") ? code : "{#{code}}"
        ast = parse_ruby(source)
        next [] unless ast # a syntax error is the Ruby linter's business

        ast.children.filter_map { |pair| static_class_value(pair) }
      end.flat_map(&:split)
    end

    def static_class_value(pair)
      return nil if (children = pair.children).empty?

      key, value = children
      return nil unless key && value
      return nil unless STATIC_TYPES.include?(key.type) &&
                        key.children.first.to_sym == :class &&
                        STATIC_TYPES.include?(value.type)

      value.children.first.to_s
    end
  end
end
