# This is a Modal component.
# @!parse class Daisy::Actions::ModalComponent < LocoMotion::BaseComponent; end
class Daisy::Actions::ModalComponent < LocoMotion.configuration.base_component_class
  set_component_name :modal

  define_parts :dialog, :box, :actions,
    :activator, :close_icon, :title, :start_actions, :end_actions

  renders_one :activator
  renders_one :close_icon
  renders_one :title
  renders_many :start_actions
  renders_many :end_actions

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
  # @overload initialize(closable: true, title: nil)
  #   @param closable [Boolean] Whether or not the modal should allow closing.
  #   @param title [String] A simple title that you would like the component to
  #     render above the main content of the modal. Accessible through the
  #     {simple_title} accessor.
  #
  def initialize(*args, **kws, &block)
    super

    @dialog_id ||= SecureRandom.uuid
    @closable = config_option(:closable, true)
    @simple_title = kws[:title]

    init_component
    init_box
  end

  private

  def init_component
    set_tag_name(:component, :dialog)
    add_html(:component, id: dialog_id)
  end

  def init_box
    add_css(:box, 'modal-box')
  end
end
