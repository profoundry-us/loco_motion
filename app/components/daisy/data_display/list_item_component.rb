# frozen_string_literal: true

module Daisy
  module DataDisplay
    #
    # The ListItem component represents an individual row within a List component.
    # It provides a consistent layout for displaying content in a list format.
    #
    # @loco_example Basic Usage
    #   = daisy_list do |list|
    #     - list.with_item { "Simple list item" }
    #
    # @loco_example With Image
    #   = daisy_list do |list|
    #     - list.with_item do
    #       = image_tag(src: "profile.jpg", class: "rounded-full size-8")
    #       User Profile
    #
    class ListItemComponent < LocoMotion::BaseComponent
      # Called before rendering to setup the component CSS and structure
      def before_render
        set_tag_name(:component, :li)
        add_css(:component, "list-row")
      end

      def call
        part(:component) { content }
      end
    end
  end
end
