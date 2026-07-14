# frozen_string_literal: true

module LocoMotion
  #
  # Holds the per-part CSS, HTML, tag name, and modifier configuration that
  # every component builds from its constructor keyword arguments. Each
  # component owns one `ComponentConfig` instance (via `BaseComponent#config`)
  # that tracks the default and user-supplied values for every part declared
  # with `define_part`, and merges them together when the part is rendered.
  #
  class ComponentConfig
    include LocoMotion::Concerns::InspectableComponent

    attr_reader :component, :parts, :options, :modifiers, :size

    #
    # Create a new config for the given component instance and process its
    # keyword arguments into per-part defaults.
    #
    # @param component [LocoMotion::BaseComponent] The component instance
    #   this config belongs to.
    #
    # @option kws modifiers [Array<Symbol>] The component's modifiers (e.g.
    #   `:primary`), validated against the component's `valid_modifiers`.
    #
    # @option kws modifier [Symbol] Singular alias for passing a single
    #   modifier; merged into `modifiers`.
    #
    # @option kws size [Symbol] The component's size, if it declares
    #   `valid_sizes`.
    #
    # @option kws {part}_css [String, Array<String>] CSS classes to add to
    #   the given part (e.g. `wrapper_css`).
    #
    # @option kws {part}_html [Hash] HTML attributes to deep-merge onto the
    #   given part (e.g. `wrapper_html`).
    #
    # @option kws {part}_aria [Hash] `aria-*` attributes to deep-merge onto
    #   the given part, nested under `html[:aria]` (e.g. `wrapper_aria`).
    #
    # @option kws {part}_data [Hash] `data-*` attributes to deep-merge onto
    #   the given part, nested under `html[:data]` (e.g. `wrapper_data`).
    #
    # @option kws {part}_tag_name [String, Symbol] The HTML tag to render the
    #   given part as (e.g. `wrapper_tag_name`).
    #
    def initialize(component, **kws)
      @component = component
      @options = kws

      @parts = {}
      @modifiers = (kws[:modifiers] || [kws[:modifier]]).compact
      @size = kws[:size]

      build
      validate
    end

    #
    # Populate {#parts} with the default and user-supplied CSS, HTML, tag
    # name, and Stimulus controllers for every part the component declares,
    # then layer in the component-level shorthand options (see
    # {#merge_user_options!}).
    #
    def build
      # Allow users to pass css/html for a specific part (i.e. modal_dialog)
      @component.component_parts.each do |part, defaults|
        @parts[part] = {
          default_css: [],
          default_html: {},
          default_tag_name: defaults[:tag_name] || :div,
          default_stimulus_controllers: [],

          user_css: @options["#{part}_css".to_sym] || [],
          user_html: @options["#{part}_html".to_sym] || {},
          user_tag_name: @options["#{part}_tag_name".to_sym],
          user_stimulus_controllers: @options["#{part}_controllers".to_sym] || []
        }

        # Allow users to pass `{part}_aria` / `{part}_data` as a shorthand for
        # nesting `aria:` / `data:` hashes inside `{part}_html`.
        part_aria = @options["#{part}_aria".to_sym]
        part_data = @options["#{part}_data".to_sym]

        @parts[part][:user_html] = @parts[part][:user_html].deep_merge(aria: part_aria) if part_aria
        @parts[part][:user_html] = @parts[part][:user_html].deep_merge(data: part_data) if part_data
      end

      # Allow useres to pass some shortened attributes for the component part
      merge_user_options!(**@options)
    end

    #
    # Add specific component user options if they pass shortened attributes.
    #
    # @option kws tag_name [String, Symbol] The HTML tag to render the
    #   component part as.
    #
    # @option kws css [String, Array<String>] CSS classes to add to the
    #   component part.
    #
    # @option kws html [Hash] HTML attributes to deep-merge onto the
    #   component part.
    #
    # @option kws aria [Hash] `aria-*` attributes to deep-merge onto the
    #   component part, nested under `html[:aria]`.
    #
    # @option kws data [Hash] `data-*` attributes to deep-merge onto the
    #   component part, nested under `html[:data]`.
    #
    # @option kws controller [String] A single Stimulus controller to add to
    #   the component part.
    #
    # @option kws controllers [Array<String>] Stimulus controllers to add to
    #   the component part.
    #
    def merge_user_options!(**kws)
      @parts[:component][:user_tag_name] = kws[:tag_name] if kws[:tag_name]
      @parts[:component][:user_css].push(kws[:css]) if kws[:css]
      @parts[:component][:user_html].deep_merge!(kws[:html]) if kws[:html]
      @parts[:component][:user_html].deep_merge!(aria: kws[:aria]) if kws[:aria]
      @parts[:component][:user_html].deep_merge!(data: kws[:data]) if kws[:data]
      @parts[:component][:user_stimulus_controllers].push(kws[:controller]) if kws[:controller]
      @parts[:component][:user_stimulus_controllers].push(kws[:controllers]) if kws[:controllers]
    end

    #
    # Merge additional options into the defaults config by combining the new
    # options with the existing options, rather than overwriting (where
    # possible).
    #
    # HTML will be deep merged, CSS will be appended, and tag_name will be
    # overwritten.
    #
    # @param kws [Hash] Keyword arguments using the same per-part `{part}_*`
    #   shorthand pattern as {#initialize} (e.g. `wrapper_css`,
    #   `wrapper_html`), plus the component-level options handled by
    #   {#merge_user_options!}.
    #
    def smart_merge!(**kws)
      @component.component_parts.each_key do |part|
        set_tag_name(part, kws["#{part}_tag_name".to_sym])
        add_css(part, kws["#{part}_css".to_sym])
        add_html(part, kws["#{part}_html".to_sym])
        add_aria(part, kws["#{part}_aria".to_sym])
        add_data(part, kws["#{part}_data".to_sym])

        controllers = kws["#{part}_controllers".to_sym] || []

        controllers.each do |controller_name|
          add_stimulus_controller(part, controller_name)
        end
      end

      # Make sure to merge any user-provided options as well
      merge_user_options!(**kws)
    end

    #
    # Returns the part for the request part name or an empty hash if none was
    # found.
    #
    # @param part_name [Symbol] The name of the part to look up.
    #
    def get_part(part_name)
      @parts[part_name] || {}
    end

    #
    # Sets the default tag name for the requested component part.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param tag_name [String, Symbol] The default HTML tag to render the
    #   part as.
    #
    def set_tag_name(part_name, tag_name)
      @parts[part_name][:default_tag_name] = tag_name if tag_name
    end

    #
    # Adds default CSS to the requested component part.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param css [String, Array<String>] The CSS classes to add.
    #
    def add_css(part_name, css)
      @parts[part_name][:default_css] << css if css
    end

    #
    # Adds default HTML to the requested component part.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param html [Hash] The HTML attributes to deep-merge onto the part.
    #
    def add_html(part_name, html)
      @parts[part_name][:default_html] = @parts[part_name][:default_html].deep_merge(html) if html
    end

    #
    # Adds default `aria-*` attributes to the requested component part. This
    # is a convenience wrapper around {add_html} that nests the given hash
    # under the `aria:` key, so `add_aria(:component, label: "Save")` renders
    # `aria-label="Save"`.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param aria [Hash] The `aria-*` attributes to deep-merge onto the part.
    #
    def add_aria(part_name, aria)
      add_html(part_name, { aria: aria }) if aria
    end

    #
    # Adds default `data-*` attributes to the requested component part. This
    # is a convenience wrapper around {add_html} that nests the given hash
    # under the `data:` key, so `add_data(:component, foo: "bar")` renders
    # `data-foo="bar"`.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param data [Hash] The `data-*` attributes to deep-merge onto the part.
    #
    def add_data(part_name, data)
      add_html(part_name, { data: data }) if data
    end

    #
    # Add a default Stimulus (Javascript) controller to the requested
    # component part.
    #
    # @param part_name [Symbol] The name of the part to update.
    # @param controller_name [String] The name of the Stimulus controller to
    #   add.
    #
    def add_stimulus_controller(part_name, controller_name)
      @parts[part_name] ||= {}
      @parts[part_name][:default_stimulus_controllers] ||= []
      @parts[part_name][:default_stimulus_controllers] << controller_name
    end

    #
    # Validate the component config and throw errors if there are issues.
    #
    def validate
      validate_modifiers
    end

    #
    # Validate that all of the modifiers are correct.
    #
    def validate_modifiers
      # Check to make sure they have passed a valid / defined modifier
      (@modifiers || []).each do |modifier|
        if modifier.present? && !@component.valid_modifiers.include?(modifier)
          raise LocoMotion::InvalidModifierError.new(modifier, @component)
        end
      end
    end

    #
    # Validates that the requested part is valid for the component.
    #
    # @param part_name [Symbol] The name of the part to validate.
    #
    def validate_part(part_name)
      raise LocoMotion::UnknownPartError.new(part_name, @component) unless valid_parts.include?(part_name)
    end

    #
    # Return a list of valid parts for the component.
    #
    def valid_parts
      @parts.keys
    end

    #
    # Render a Hash version of the config.
    #
    def to_h
      {
        options: @options,
        parts: @parts,
        modifiers: @modifiers,
        size: @size
      }
    end

    #
    # Builds a formatted inspect string (via
    # {LocoMotion::Concerns::InspectableComponent}) showing the options,
    # parts, modifiers, and size.
    #
    def inspect
      build_inspect_string("options", "parts", "modifiers", "size", suffix: ">")
    end
  end
end
