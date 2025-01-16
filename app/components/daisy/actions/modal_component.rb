#
# The Modal component renders a modal dialog that can be opened and closed. It
# includes a backdrop, a close icon, a title, and actions.
#
# @part dialog The main `<dialog>` container.
# @part box The container for the modal content.
# @part close_icon_wrapper The container for the close icon.
# @part close_icon The default close icon.
# @part backdrop The backdrop that covers the rest of the screen.
# @part title Container for the default title for the modal.
# @part actions Container for all modal actions.
# @part start_actions Container for the left (start) aligned actions for the
#   modal.
# @part end_actions The end actions for the modal.
#
# @slot activator A custom (non-button) activator for the modal.
# @slot button The button that triggers the modal. Defaults to a standard Daisy
#   button whose title matches the modal title.
# @slot close_icon A custom close icon for the modal.
# @slot title A custom title for the modal.
# @slot start_actions Left (or start) aligned actions for the modal.
# @slot end_actions Right (or end) aligned actions for the modal.
#
# @loco_example Basic Usage
#   = daisy_modal(title: "Simple Modal") do |modal|
#     - modal.with_activator do
#       - onclick = "document.getElementById('#{modal.dialog_id}').showModal()"
#       = daisy_button(css: 'btn-primary', html: { onclick: onclick }) do
#         Open Modal
#
#     Here is some really long modal content that should go well past the
#     spot where the close icon appears...
#
#     - modal.with_end_actions(css: "flex flex-row items-center gap-2") do
#       %form{ method: :dialog }
#         = daisy_button do
#           Cancel
#       %form{ action: "", method: :get }
#         %input{ type: "hidden", name: "submitted", value: "true" }
#         = daisy_button(css: "btn-primary") do
#           Submit
#
class Daisy::Actions::ModalComponent < LocoMotion::BaseComponent
  set_component_name :modal

  define_parts :dialog, :box, :actions, :close_icon_wrapper, :close_icon,
    :backdrop, :title, :start_actions, :end_actions

  renders_one :activator, LocoMotion::BasicComponent.build(html: { role: "button", tabindex: 0 })
  renders_one :button, Daisy::Actions::ButtonComponent
  renders_one :close_icon
  renders_one :title
  renders_one :start_actions
  renders_one :end_actions

  # @return [Boolean] Whether or not this dialog can be closed.
  attr_reader :closable
  alias :closable? :closable

  # @return [String] The unique ID for the `<dialog>` element.
  attr_reader :dialog_id

  # @return [String] Accessor for the `title` string passed via the component
  #   config.
  attr_reader :simple_title

  #
  # Instantiate a new Modal component. All options are expected to be passed as
  # keyword arguments.
  #
  # @param args [Array] Currently unused and passed through to the
  #   BaseComponent.
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws dialog_id [String] A specific ID you would like the dialog to
  #   use. Auto-generates a random ID using `SecureRandom.uuid` if not provided.
  # @option kws closable [Boolean] Whether or not the modal should allow
  #   closing.
  # @option kws title [String] A simple title that you would like the
  #   component to render above the main content of the modal (see
  #   {simple_title}).
  #
  def initialize(*args, **kws, &block)
    super

    @dialog_id = config_option(:dialog_id, SecureRandom.uuid)
    @closable = config_option(:closable, true)
    @simple_title = config_option(:title)
  end

  #
  # Sets up the component with various CSS classes and HTML attributes.
  #
  def before_render
    setup_activator_or_button
    setup_component
    setup_backdrop
    setup_box
    setup_close_icon
    setup_title
    setup_actions
  end

  private

  def setup_activator_or_button
    onclick = "document.getElementById('#{dialog_id}').showModal()"

    element = if activator?
      activator
    else
      button || default_button
    end

    element.add_html(:component, { onclick: onclick })
  end

  def setup_component
    set_tag_name(:component, :dialog)
    add_html(:component, id: dialog_id)
    add_css(:component, "modal")

    add_stimulus_controller(:component, "modal")
  end

  def setup_backdrop
    set_tag_name(:backdrop, :form)
    add_html(:backdrop, { method: "dialog" })
    add_css(:backdrop, "modal-backdrop")
  end

  def setup_box
    add_css(:box, "modal-box relative")
  end

  def setup_close_icon
    set_tag_name(:close_icon_wrapper, :form)
    add_html(:close_icon_wrapper, { method: "dialog" })

    set_tag_name(:close_icon, :button)
    add_css(:close_icon, "absolute top-2 right-2 p-1 btn btn-circle btn-ghost btn-xs")
  end

  def setup_title
    add_css(:title, "mb-2 text-xl font-bold")
  end

  def setup_actions
    add_css(:actions, "mt-2 flex flex-row items-center justify-between")
  end

  # Provide a default button if no button is supplied.
  def default_button
    with_button(simple_title)
  end
end
