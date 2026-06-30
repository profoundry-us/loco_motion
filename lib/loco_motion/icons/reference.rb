# frozen_string_literal: true

module LocoMotion
  module Icons
    #
    # Parses a qualified icon token into its library, name, and variant.
    #
    # The grammar is `[library:]name[/variant]` — the same form used in
    # {LocoMotion::Configuration#icon_safelist} — so an icon reference is fully
    # self-contained wherever it appears (a `loco_icon` call, a component's
    # `icon:` option, or the safelist). That keeps rendering and treeshaking in
    # lockstep: the {LocoMotion::Icons::Scanner} extracts exactly the token the
    # {LocoMotion::Icons::Renderer} resolves.
    #
    #   "heart"               => library: default,  name: "heart",  variant: default
    #   "lucide:heart"        => library: "lucide",  name: "heart",  variant: default
    #   "phosphor:gear/bold"  => library: "phosphor", name: "gear",  variant: "bold"
    #   "bolt/solid"          => library: default,  name: "bolt",   variant: "solid"
    #
    # An explicit `library:` / `variant:` passed alongside the token is used
    # only as the default — anything the token itself specifies wins.
    #
    module Reference
      module_function

      #
      # @param token [String, Symbol] The icon token, `[library:]name[/variant]`.
      #
      # @param default_library [String, Symbol, nil] Library to use when the
      #   token does not name one.
      #
      # @param default_variant [String, Symbol, nil] Variant to use when the
      #   token does not name one.
      #
      # @return [Hash] `{ library:, variant:, name: }`. `name` and `library`
      #   are always Strings (library names are identifiers, and a consistent
      #   type lets references dedupe and sort regardless of whether the default
      #   was passed as a Symbol or String). `variant` keeps the resolved type
      #   (or `nil`), since some backends distinguish `:outline` from
      #   `"outline"`.
      #
      def parse(token, default_library: nil, default_variant: nil)
        before_variant, _slash, variant_part = token.to_s.partition("/")
        library_part, colon, name_part = before_variant.partition(":")

        if colon.empty?
          name = library_part
          library = default_library
        else
          name = name_part
          library = library_part
        end

        {
          library: library&.to_s,
          variant: variant_part.empty? ? default_variant : variant_part,
          name: name
        }
      end
    end
  end
end
