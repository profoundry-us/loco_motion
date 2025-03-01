#
# The Chat component renders a messaging interface with support for avatars,
# message bubbles, and optional header and footer content. It's perfect for
# displaying conversations, comments, or any message-based interactions.
#
# @slot avatar An optional avatar for the message sender. Uses the
#   {AvatarComponent} with preset styling for chat messages.
#
# @slot header A header section above the message bubbles, typically used for
#   sender name or timestamp.
#
# @slot footer A footer section below the message bubbles, often used for
#   message status or metadata.
#
# @slot bubble+ One or more message bubbles containing the actual message
#   content.
#
# @loco_example Basic Usage
#   = daisy_chat do |chat|
#     - chat.with_bubble do
#       Hello! How can I help you today?
#
# @loco_example With Avatar
#   = daisy_chat do |chat|
#     - chat.with_avatar(src: "avatar.jpg")
#     - chat.with_bubble do
#       Hi there! I'm your assistant.
#
# @loco_example Complete Message
#   = daisy_chat do |chat|
#     - chat.with_avatar(icon: "user")
#     - chat.with_header do
#       .font-bold John Doe
#       .text-xs 2 minutes ago
#     - chat.with_bubble do
#       Can you help me with my account?
#     - chat.with_bubble do
#       I can't seem to find the settings page.
#     - chat.with_footer do
#       .text-xs Sent from Web App
#
# @loco_example End-aligned Chat
#   = daisy_chat(css: "chat-end") do |chat|
#     - chat.with_avatar(src: "user.jpg")
#     - chat.with_bubble do
#       Sure! The settings page is under your profile menu.
#
class Daisy::DataDisplay::ChatComponent < LocoMotion::BaseComponent
  renders_one :avatar, Daisy::DataDisplay::AvatarComponent.build(css: "chat-image", icon_css: "size-6 text-base-100", wrapper_css: "w-10 rounded-full")
  renders_one :header, LocoMotion::BasicComponent.build(css: "chat-header [:where(&)]:text-neutral-500")
  renders_one :footer, LocoMotion::BasicComponent.build(css: "chat-footer [:where(&)]:text-neutral-500")

  renders_many :bubbles, LocoMotion::BasicComponent.build(css: "chat-bubble")

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
