# frozen_string_literal: true

#
# The Modal component renders a modal dialog that can be opened and closed. It
# provides a structured way to display content that requires user attention or
# interaction, such as forms, confirmations, or detailed information.
#
# Note that the modal uses the HTML `<dialog>` element and its native methods
# (`showModal()` and `close()`). This provides better accessibility and keyboard
# navigation compared to div-based modals.
#
# @note Register the `loco-modal` Stimulus controller (see the Install guide)
#   to drive the dialog from JavaScript. It is attached to the `<dialog>`
#   automatically but stays inert until registered, so basic modals keep
#   working without it. The controller adds `loco-modal#open` and
#   `loco-modal#close` actions and dispatches bubbling `loco-modal:open` /
#   `loco-modal:close` events. Because the native `<dialog>` `close` event does
#   not bubble, `loco-modal:close` fires for every close — the Escape key, the
#   backdrop, a `<form method="dialog">` submit, or the `close` action.
#
# @part box The container for the modal content, providing padding and layout.
# @part close_icon_wrapper The container for the close icon, positioned in the
#   top-right corner.
# @part close_icon The default close icon button.
# @part backdrop The full-bleed backdrop element behind the open modal (also
#   the click-outside catcher). Style the page behind the modal through
#   `backdrop_css` — e.g. `backdrop_css: "backdrop-blur-sm"` for a
#   frosted-glass effect.
# @part title Container for the modal title, styled for prominence.
# @part actions Container for all modal action buttons.
# @part leading_actions Container for left-aligned action buttons.
# @part trailing_actions Container for right-aligned action buttons.
#
# @slot activator A custom element that opens the modal. Automatically adds
#   `role="button"` and a default `tabindex="0"` for accessibility; pass
#   `html: { tabindex: -1 }` (etc.) to override either default.
# @slot button The button that opens the modal. Defaults to a standard Daisy
#   button with the modal's title.
# @slot close_icon A custom close button to replace the default 'X' icon.
# @slot title Custom title content, replacing the default text title.
# @slot leading_actions Left-aligned buttons, typically for secondary actions
#   like "Cancel".
# @slot trailing_actions Right-aligned buttons, typically for primary actions
#   like "Submit" or "Save".
#
# @loco_example Basic Modal
#   = daisy_modal(title: "Simple Modal") do |modal|
#     - modal.with_button(css: "btn-primary") { "Open Modal" }
#     %p This is a basic modal with some content.
#     - modal.with_trailing_actions do
#       %form{ method: :dialog }
#         = daisy_button { "Close" }
#
# @loco_example Form Modal
#   = daisy_modal(title: "Edit Profile") do |modal|
#     - modal.with_button { "Edit Profile" }
#     = form_with(model: @user) do |f|
#       .space-y-4
#         = f.text_field :name, class: "input w-full"
#         = f.email_field :email, class: "input w-full"
#     - modal.with_leading_actions do
#       %form{ method: :dialog }
#         = daisy_button { "Cancel" }
#     - modal.with_trailing_actions do
#       = daisy_button(css: "btn-primary", type: "submit") { "Save Changes" }
#
# @loco_example Custom Activator
#   = daisy_modal(title: "User Details") do |modal|
#     - modal.with_activator do
#       .flex.items-center.gap-2.cursor-pointer
#         = loco_icon("user-circle")
#         %span View Details
#
#     %dl.space-y-2
#       %dt Name
#       %dd John Doe
#       %dt Email
#       %dd john@example.com
#
#     - modal.with_trailing_actions do
#       %form{ method: :dialog }
#         = daisy_button { "Close" }
#
# @loco_example Blurred Backdrop
#   -# Frost the page behind the modal with a stock Tailwind utility on the
#   -# backdrop part. Note that Tailwind v4 has no bare `backdrop-blur` —
#   -# always pick a size (`backdrop-blur-xs` ~4px, `-sm` ~8px, `-md` ~12px).
#   = daisy_modal(title: "Blurred Backdrop", backdrop_css: "backdrop-blur-sm") do |modal|
#     - modal.with_button(css: "btn-primary") { "Open Modal" }
#     %p The page behind this modal is frosted; the modal box stays crisp.
#
# @loco_example Global Modal
#   = daisy_modal(title: "Settings", trigger: false, dialog_id: "app-modal") do |modal|
#     %p This modal has no built-in trigger — open it from anywhere.
#     - modal.with_trailing_actions do
#       = daisy_button(action: "loco-modal#close") { "Close" }
#
#   = daisy_button(html: { onclick: "document.getElementById('app-modal').showModal()" }) { "Open" }
#
# @loco_example Global Modal with a Turbo Frame
#   -# One shared modal; each link streams its content into the frame, which
#   -# opens the dialog on load. No per-row modals, no inline JavaScript.
#   = daisy_modal(trigger: false, turbo_frame_id: "contact", dialog_id: "contact-modal")
#
#   = link_to "Edit Contact", edit_contact_path(1), data: { turbo_frame: "contact" }
#
module Daisy
  module Actions
    class ModalComponent < LocoMotion::BaseComponent
      set_component_name :modal

      define_parts :box, :actions, :close_icon_wrapper, :close_icon,
                   :backdrop, :title, :leading_actions, :trailing_actions,
                   :turbo_frame

      renders_one :activator, LocoMotion::BasicComponent
      renders_one :button, Daisy::Actions::ButtonComponent
      renders_one :close_icon
      renders_one :title
      renders_one :leading_actions
      renders_one :trailing_actions

      # @return [Boolean] Whether or not this dialog can be closed.
      attr_reader :closable
      alias closable? closable

      # @return [Boolean] Whether or not a built-in trigger is rendered. When
      #   false, only the `<dialog>` is rendered (a "Global Modal").
      attr_reader :trigger
      alias trigger? trigger

      # @return [String, nil] The id for the `<turbo-frame>` rendered inside the
      #   modal (the Turbo Frame "Global Modal" pattern), or nil when unused.
      attr_reader :turbo_frame_id

      # @return [String] The unique ID for the `<dialog>` element.
      attr_reader :dialog_id

      # @return [String] Accessor for the `title` string passed via the component
      #   config.
      attr_reader :simple_title

      #
      # Creates a new instance of the ModalComponent.
      #
      # @param title [String] The title of the modal. Used in both the modal header
      #   and the default trigger button.
      #
      # @param kws [Hash] The keyword arguments for the component.
      #
      # @option kws title [String] The title of the modal. You can also pass this as
      #   the first argument.
      #
      # @option kws closable [Boolean] If true (default), shows a close icon in the
      #   top-right corner.
      #
      # @option kws dialog_id [String] A custom ID for the dialog element. If not
      #   provided, a unique ID will be generated.
      #
      # @option kws trigger [Boolean] When true (default) and no custom activator
      #   or button slot is given, a default button (labeled with the title) is
      #   rendered to open the modal. Pass false to render only the `<dialog>`
      #   with no built-in trigger — a "Global Modal" that you place once and
      #   open from elsewhere (a link, another component, or JavaScript).
      #
      # @option kws turbo_frame_id [String] Renders an empty `<turbo-frame>` with
      #   this id inside the modal and wires the `loco-modal` controller to open
      #   the dialog when that frame loads (and clear it on close). Combine with
      #   `trigger: false` for the Hotwire "Global Modal" pattern: place one
      #   modal in your layout and point `data-turbo-frame` links at this id to
      #   stream remote content into it. Requires the registered controller.
      #
      def initialize(title = nil, **kws, &block)
        super

        @dialog_id = config_option(:dialog_id, SecureRandom.uuid)
        @closable = config_option(:closable, true)
        @trigger = config_option(:trigger, true)
        @turbo_frame_id = config_option(:turbo_frame_id, nil)
        @simple_title = config_option(:title, title)
      end

      #
      # Sets up the component with various CSS classes and HTML attributes.
      #
      def before_render
        setup_activator_or_button
        setup_component
        setup_backdrop
        setup_box
        setup_turbo_frame
        setup_close_icon
        setup_title
        setup_actions
      end

      private

      def setup_activator_or_button
        element =
          if activator?
            activator
          elsif button?
            button
          elsif trigger?
            default_button
          end

        # Global Modal mode (`trigger: false`) with no activator or button has
        # nothing to wire — render just the `<dialog>`.
        return unless element

        # Accessibility defaults for a custom activator live in the part's
        # default HTML so a call-time `html:` (e.g. `tabindex: -1`) overrides
        # them.
        element.add_html(:component, role: "button", tabindex: 0) if activator?

        onclick = "document.getElementById('#{dialog_id}').showModal()"
        element.add_html(:component, onclick: onclick)
      end

      def setup_component
        set_tag_name(:component, :dialog)
        add_html(:component, id: dialog_id)
        add_css(:component, "modal")

        # Attach the optional `loco-modal` Stimulus controller. It is inert
        # until an app registers it, so modals keep working without any JS.
        add_stimulus_controller(:component, "loco-modal")
      end

      def setup_backdrop
        set_tag_name(:backdrop, :form)
        add_html(:backdrop, { method: "dialog" })
        add_css(:backdrop, "modal-backdrop")
      end

      def setup_box
        add_css(:box, "modal-box relative")
      end

      def setup_turbo_frame
        return unless @turbo_frame_id.present?

        set_tag_name(:turbo_frame, "turbo-frame")
        add_html(:turbo_frame, id: @turbo_frame_id)

        # Hand the frame id to the `loco-modal` controller (as its `turboFrameId`
        # value) so it can open the dialog on `turbo:frame-load` and clear the
        # frame on close.
        add_data(:component, "loco-modal-turbo-frame-id-value": @turbo_frame_id)
      end

      def setup_close_icon
        set_tag_name(:close_icon_wrapper, :form)
        add_html(:close_icon_wrapper, { method: "dialog" })

        set_tag_name(:close_icon, :button)
        add_css(:close_icon,
                "where:absolute where:top-2 where:right-2 where:p-1 where:btn where:btn-circle where:btn-ghost where:btn-xs")
      end

      def setup_title
        set_tag_name(:title, "h4")
        add_css(:title, "where:mb-2 where:text-xl where:font-bold")
      end

      def setup_actions
        add_css(:actions, "where:mt-2 where:flex where:flex-row where:items-center where:justify-between")
      end

      # Provide a default button if no button is supplied.
      def default_button
        with_button(simple_title)
      end
    end
  end
end
