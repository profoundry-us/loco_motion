# frozen_string_literal: true

# helpers.rb walks COMPONENTS at load time — it uses ActiveSupport inflections
# and defines the helpers on ActionView — so both must be loaded first, since
# haml_lint runs outside Rails. Costs ~77ms standalone and nothing inside an
# app where they are already loaded.
require "active_support/core_ext/string/inflections"
require "action_view"
require_relative "../helpers"

module LocoMotion
  module Lint
    # Derives the "DaisyUI class -> LocoMotion helper" map that the component
    # usage linter enforces.
    #
    # The map is DERIVED, never hand-maintained. Every entry comes from
    # {LocoMotion::COMPONENTS} paired with the component's own
    # `add_css(:component, "...")` declaration, so a component and the rule
    # covering it cannot drift apart: adding a component adds its coverage in
    # the same commit, and {.unmapped} makes a component that declares no class
    # a visible, testable fact rather than a silent gap.
    #
    # This replaces a hand-written list that had reached 25 of 70 components.
    module ComponentMap
      module_function

      # Tailwind variants (`sm:`, `where:`) and utilities are not component
      # classes — a view is free to use them, so they must never be flagged.
      def component_class?(token)
        !token.include?(":") && token.match?(/\A[a-z][a-z0-9-]*\z/)
      end

      def underscore(string)
        string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      end

      def gem_root
        File.expand_path("../../..", __dir__)
      end

      # "Daisy::DataDisplay::CardComponent" -> app/components/daisy/data_display/card_component.rb
      def source_path(class_name)
        segments = class_name.split("::").map { |segment| underscore(segment) }
        "#{File.join(gem_root, 'app', 'components', *segments)}.rb"
      end

      # Helper names follow "#{framework}_#{name}" (see LocoMotion.define_helpers),
      # and a component may register several — the first is the canonical suggestion.
      def helper_name(class_name, meta)
        framework = underscore(class_name.split("::").first)
        "#{framework}_#{Array(meta[:names]).first}"
      end

      def declarations(source)
        source.scan(/add_css\(\s*:([a-z_]+)\s*,\s*"([^"]+)"/)
              .map { |part, css| [part, css.split(/\s+/).select { |t| component_class?(t) }] }
      end

      # A component root is sometimes a plain Tailwind utility — Countdown
      # declares only "flex", putting its DaisyUI class on child spans. Claiming
      # those would flag every .flex in every view, so they are refused and the
      # component is reported as unmapped instead. A gap is recoverable; a
      # false positive teaches people to ignore the linter.
      LAYOUT_UTILITIES = %w[
        flex grid block inline inline-block hidden contents flow-root
        relative absolute fixed sticky static isolate table
      ].freeze

      def component_tokens(decls)
        decls.select { |part, _| part == "component" }.flat_map(&:last)
      end

      def base_for(decls, names)
        tokens = component_tokens(decls)
        # A file may declare several component roots — a nested sub-component
        # (drawer-side, carousel-item) often appears BEFORE the real root — so
        # prefer the token that matches a registered helper name.
        tokens.find { |token| names.include?(token) } ||
          tokens.reject { |token| LAYOUT_UTILITIES.include?(token) }.first
      end

      # { "card" => "daisy_card", "card-body" => "daisy_card (body part)" }
      def build
        map = {}
        # Two passes so an exact name match always wins the class: Accordion and
        # Collapse both style "collapse", and it should read as daisy_collapse.
        [true, false].each do |names_only|
          LocoMotion::COMPONENTS.each do |class_name, meta|
            add_component(map, class_name, meta, names_only: names_only)
          end
        end
        map
      end

      def add_component(map, class_name, meta, names_only:)
        path = source_path(class_name)
        return unless File.exist?(path)

        names = Array(meta[:names]).map(&:to_s)
        decls = declarations(File.read(path))
        return if names_only && (names & component_tokens(decls)).empty?

        base = base_for(decls, names)
        return unless base

        helper = helper_name(class_name, meta)
        map[base] ||= helper
        add_parts(map, decls, base, helper)
      end

      # Anything extending the base ("card-body", "drawer-side") belongs to this
      # component. A part reusing a shared class like "label" belongs to no
      # single component and is left alone.
      def add_parts(map, decls, base, helper)
        decls.each do |part, tokens|
          tokens.each do |token|
            next if token == base || !token.start_with?("#{base}-")

            label = part == "component" ? "nested" : part
            map[token] ||= "#{helper} (#{label} part)"
          end
        end
      end

      # Components that declare no usable base class — they build it
      # dynamically, or style the root with utilities. Surfaced so the spec can
      # pin the list: a NEW component landing here fails the suite rather than
      # quietly going unenforced.
      def unmapped
        LocoMotion::COMPONENTS.reject do |class_name, meta|
          path = source_path(class_name)
          next false unless File.exist?(path)

          !base_for(declarations(File.read(path)), Array(meta[:names]).map(&:to_s)).nil?
        end.keys
      end
    end
  end
end
