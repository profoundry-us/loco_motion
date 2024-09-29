#
# The {ChatComponent} renders a bubble-like chat interface with an optional
# avatar, header, and footer.
#
# @slot   avatar Renders an {AvatarComponent}. Common options include:
# @option avatar [String] src The URL of the image to display.
# @option avatar [String] icon A heroicon to be displayed instead of an image.
#
# @slot header [LocoMotion::BasicComponent] Renders a single header.
# @slot footer [LocoMotion::BasicComponent] Renders a single footer.
# @slot message [LocoMotion::BasicComponent] Renders one or more messages.
#
# @example Basic Chat
#    !!!ruby
#    = daisy_chat do |chat|
#      - chat.with_message do
#        I can't believe it's not the weekend yet!
#
class Daisy::DataDisplay::ChatComponent < LocoMotion.configuration.base_component_class
  renders_one :avatar, Daisy::DataDisplay::AvatarComponent.build(css: "chat-image", icon_css: "size-6 text-base-100", wrapper_css: "w-10 rounded-full")
  renders_one :header, LocoMotion::BasicComponent.build(css: "chat-header [:where(&)]:text-neutral-500")
  renders_one :footer, LocoMotion::BasicComponent.build(css: "chat-footer [:where(&)]:text-neutral-500")

  renders_many :messages, LocoMotion::BasicComponent.build(css: "chat-bubble")

  #
  # Sets up the component with various CSS classes and HTML attributes.
  #
  #  - `chat` is always added
  #  - `chat-start` is added if the component does not already have `chat-start` or `chat-end`
  #
  def before_render
    add_css(:component, "chat")
    add_css(:component, "chat-start") unless rendered_css(:component).match?("chat-(start|end)")
  end
end
