# frozen_string_literal: true

module Daisy
  module DataDisplay
    # The Avatar component displays an image, icon, or placeholder text to represent
    # a user or entity. It provides a consistent, circular display with fallback
    # options when an image is not available.
    #
    # Includes the {LocoMotion::Concerns::TippableComponent} module to enable easy
    # tooltip addition.
    #
    # It utilizes the CSS `where()` pseudo-class to reduce the specificity to 0 to
    # allow for easy overriding while giving you some sane defaults.
    #
    # @note When using a placeholder avatar (no `src` or `icon`), the wrapper
    #   defaults to `where:bg-neutral where:text-neutral-content` so the
    #   placeholder text is readable. These defaults are suppressed whenever
    #   `skeleton` appears in `wrapper_css`, allowing the skeleton shimmer to
    #   render correctly without the neutral background bleeding through.
    #   Use `wrapper_css: "skeleton"` to display a properly colored skeleton
    #   avatar.
    #
    # @part wrapper The outer container that maintains the avatar's shape and size.
    # @part img The image element when an image source is provided.
    # @part icon The icon element when an icon is specified.
    # @part placeholder The container for placeholder content when no image or icon
    #   is provided.
    #
    # @loco_example Basic Usage with Image
    #   = daisy_avatar(src: "https://example.com/avatar.jpg")
    #
    # @loco_example With Icon
    #   = daisy_avatar(icon: "user")
    #
    # @loco_example With Custom Icon Styling
    #   = daisy_avatar(icon: "user", icon_css: "text-yellow-400")
    #
    # @loco_example With Placeholder Text
    #   = daisy_avatar do
    #     JD
    #
    # @loco_example With Custom Size
    #   = daisy_avatar(src: "avatar.jpg", css: "size-16")
    #
    # @loco_example With Tooltip
    #   = daisy_avatar(src: "avatar.jpg", tip: "John Doe")
    #
    class AvatarComponent < LocoMotion::BaseComponent
      include LocoMotion::Concerns::IconableComponent
      include LocoMotion::Concerns::LinkableComponent
      include LocoMotion::Concerns::TippableComponent

      set_component_name :avatar

      define_parts :wrapper, :img, :placeholder

      # Create a new avatar component.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws src [String] URL to the avatar image. If not provided, the
      #   component will display an icon or placeholder content.
      #
      # @option kws icon [String] Name of the icon to display when no image is
      #   provided. If neither src nor icon is provided, placeholder content from
      #   the block will be shown.
      #
      # @option kws tip [String] The tooltip text to display when hovering over
      #   the component.
      #
      # @option kws alt [String] The alt text for the image, used by screen
      #   readers and shown when the image fails to load. Omitted when not
      #   provided.
      #
      def initialize(**kws, &block)
        super

        @src = config_option(:src)
        @alt = config_option(:alt)
      end

      def before_render
        # Run component setup *before* super to allow BaseComponent hooks to run last
        setup_component

        super
      end

      private

      # The avatar renders its icon inside the wrapper part and DaisyUI's
      # `.avatar` is already inline-flex, so Iconable's root layout classes
      # have nothing to lay out here.
      def iconable_root_css; end

      def setup_component
        add_css(:component, "avatar")

        # The where pseudo class reduces the specificity of the CSS selector to 0 so
        # that other Tailwind classes provided by the user will take presedence.
        add_css(:wrapper, "where:w-24 where:rounded-full")

        if @src.present?
          set_tag_name(:img, :img)
          add_html(:img, { src: @src, title: @content, alt: @alt })
        else
          add_css(:component, "avatar-placeholder")

          # Suppress neutral defaults when skeleton is present — where:bg-neutral
          # bleeds through skeleton's transparent gradient due to CSS layer order.
          unless config_option(:wrapper_css).to_s.match?(/\bskeleton/)
            add_css(:wrapper, "where:bg-neutral where:text-neutral-content")
          end
        end

        # Concern setup is handled by BaseComponent hook via super in before_render
        # setup_tippable_component
      end
    end
  end
end
