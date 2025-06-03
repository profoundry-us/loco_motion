#
# The SkeletonComponent creates loading placeholder elements that mimic the
# shape and size of content that is being loaded. This provides users with a
# visual indication of the content's layout before it arrives, reducing
# perceived loading times and improving user experience.
#
# Skeletons can be used in two ways:
# 1. As standalone shapes with custom dimensions.
# 2. As a modifier class on existing components to create component-specific
#    loading states.
#
# @loco_example Basic Shapes
#   = daisy_skeleton(css: "size-24 rounded-full")
#   = daisy_skeleton(css: "w-36 h-20")
#   = daisy_skeleton(css: "w-48 h-5")
#
# @loco_example Component Loading States
#   = daisy_badge(css: "badge-lg skeleton text-slate-400") do
#     Loading...
#
#   = daisy_button(css: "skeleton text-transparent") do
#     Loading...
#
#   = daisy_alert(css: "skeleton")
#
#   = daisy_chat do |chat|
#     - chat.with_avatar(wrapper_css: "skeleton")
#     - chat.with_bubble(css: "skeleton text-transparent") do
#       Loading...
#
class Daisy::Feedback::SkeletonComponent < LocoMotion::BaseComponent
  #
  # Creates a new Skeleton component.
  #
  # @param args [Array] Positional arguments passed to the parent class.
  # @param kws  [Hash]  Keyword arguments for customizing the skeleton.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Dimensions: `w-24`, `h-20`
  #   - Shapes: `rounded-full`, `rounded-lg`
  #   - Colors: `bg-base-200`
  #   When using with other components, combine with `text-transparent` to
  #   hide placeholder text.
  #
  def before_render
    add_css(:component, "skeleton")
  end

  def call
    part(:component) { content }
  end
end
