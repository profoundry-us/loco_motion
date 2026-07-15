# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The FigureComponent is used to display images with optional captions. It is
    # commonly used within cards and other content containers.
    #
    # @note `before_render` sets the component's tag to `<figure>`, but
    #   {LocoMotion::Concerns::LinkableComponent}'s setup runs afterward via
    #   `super` and overrides it to `<a>` whenever `href` is present. Since
    #   Figure is commonly embedded in Card's `top_figure` / `bottom_figure`
    #   slots, passing `href:` there changes the wrapping element from a
    #   `<figure>` to an `<a>`.
    #
    # @part image The image element when a source URL is provided.
    #
    # @loco_example Basic Usage
    #   = daisy_figure(src: "example.jpg")
    #
    # @loco_example With Caption
    #   = daisy_figure(src: "example.jpg") do
    #     A beautiful landscape
    #
    # @loco_example Without Image
    #   = daisy_figure do
    #     Content when no image is provided
    #
    # @loco_example Image Position Bottom
    #   = daisy_figure(src: "example.jpg", position: :bottom) do
    #     Caption appears above the image
    #
    class FigureComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::LinkableComponent

      define_part :image, tag_name: :img

      # Creates a new figure component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws src [String] URL of the image to display in the figure.
      #
      # @option kws position [Symbol] Position of the image relative to content.
      #   Must be :top (default) or :bottom.
      #
      # @option kws alt [String] The alt text for the image, used by screen
      #   readers and shown when the image fails to load. Omitted when not
      #   provided.
      #
      # @option kws href [String] A path or URL to which the user will be
      #   directed when the figure is clicked. Forces the Figure to use an
      #   `<a>` tag (see the note above about Card's figure slots).
      #
      # @option kws target [String] The HTML `target` attribute for the `<a>`
      #   tag (`_blank`, `_parent`, or a specific tab / window / iframe, etc).
      #
      # @option kws title [String] The HTML `title` attribute for the `<a>`
      #   tag, shown as a native tooltip on hover. Only applied when `href`
      #   is also provided.
      #
      # @option kws turbo_frame [String] The Turbo Frame to target, rendered
      #   as `data-turbo-frame`.
      #
      # @option kws turbo_action [String, Symbol] How Turbo Drive updates the
      #   browser history for the visit, rendered as `data-turbo-action`
      #   (e.g. `:advance` or `:replace`).
      #
      # @option kws turbo_method [String, Symbol] The HTTP method Turbo
      #   should use for the request, rendered as `data-turbo-method`
      #   (e.g. `:delete`).
      #
      # @option kws turbo_confirm [String] A confirmation prompt Turbo shows
      #   before submitting, rendered as `data-turbo-confirm`.
      #
      # @option kws action [String] A Stimulus action wired to the figure via
      #   its `data-action` attribute. Stimulus infers the `click` event, so
      #   `action: "my-controller#handle"` works as a shorthand for
      #   `action: "click->my-controller#handle"`.
      #
      # @option kws css [String] Additional CSS classes for styling.
      #
      def initialize(**kws, &block)
        super

        @src = kws[:src]
        @alt = kws[:alt]
        @position = kws[:position] || :top

        validate_position!
      end

      def before_render
        set_tag_name(:component, :figure)
        add_html(:image, { src: @src, alt: @alt }) if @src

        super
      end

      def call
        part(:component) do
          if @position == :bottom
            # Show content first, then image
            concat(content)
            concat(part(:image)) if @src
          else
            # Default: show image first, then content
            concat(part(:image)) if @src
            concat(content)
          end
        end
      end

      private

      def validate_position!
        return if %i[top bottom].include?(@position)

        raise ArgumentError, "position must be :top or :bottom, got '#{@position}'"
      end
    end
  end
end
