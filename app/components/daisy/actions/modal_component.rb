# This is a Modal component.
# @!parse class Daisy::Actions::ModalComponent < LocoMotion::BaseComponent; end
class Daisy::Actions::ModalComponent < LocoMotion.configuration.base_component_class
  set_component_name :modal

  define_parts :dialog, :box, :actions,
    :activator, :close_icon_wrapper, :close_icon,
    :backdrop,
    :title, :start_actions, :end_actions

  renders_one :activator
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
  # @overload initialize(dialog_id: nil, closable: true, title: nil)
  #   @param dialog_id [String] A specific ID you would like the dialog to use.
  #     Auto-generates a random ID using `SecureRandom.uuid` if not provided.
  #
  #   @param closable [Boolean] Whether or not the modal should allow closing.
  #
  #   @param title [String] A simple title that you would like the component to
  #     render above the main content of the modal. Accessible through the
  #     {simple_title} accessor.
  #
  def initialize(*args, **kws, &block)
    super

    @dialog_id ||= SecureRandom.uuid
    @closable = config_option(:closable, true)
    @simple_title = config_option(:title)
  end

  def before_render
    setup_component
    setup_backdrop
    setup_box
    setup_close_icon
    setup_title
    setup_actions
  end

  private

  def setup_component
    set_tag_name(:component, :dialog)
    add_html(:component, id: dialog_id)
    add_css(:component, "modal")
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
end
