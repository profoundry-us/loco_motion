# This is a Modal component.
# @!parse class LocoMotion::Actions::ModalComponent < LocoMotion::BaseComponent; end
class LocoMotion::Actions::ModalComponent < LocoMotion.configuration.component_class
  set_component_name :modal

  define_variants :top, :middle, :bottom

  define_parts :dialog, :box, :actions

  # TODO: Add a title slot? open_button passes back the modal ID? Or the modal does...

  renders_one :open_button
  renders_one :close_button
  renders_many :start_actions
  renders_many :end_actions

  # Returns the unique ID for the <dialog> element.
  attr_reader :dialog_id

  #
  # Instantiate a new Modal component.
  #
  # @overload initialize(title: nil)
  #   @param title [String] A title that you would like the component to render
  #     above the main content of the modal.
  #
  def initialize(*args, **kws, &block)
    super

    @dialog_id ||= SecureRandom.uuid
  end
end
