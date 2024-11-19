#
# The IndicatorComponent provides items positioned around it's content with the
# intention of indicating a callout or something needing attention.
#
# @slot item The items to be rendered around the content. Allows multiple.
#
# @loco_example Basic Usage
#   = daisy_indicator do |indicator|
#     - indicator.with_item do
#       = daisy_badge(title: "New!", css: "badge-accent")
#
#     = daisy_button(title: "Checkout", left_icon: "shopping-cart")
#
class Daisy::Layout::IndicatorComponent < LocoMotion::BaseComponent
  renders_many :items, LocoMotion::BasicComponent.build(css: "indicator-item")

  #
  # Adds the `indicator` CSS to the component
  #
  def before_render
    add_css(:component, "indicator")
  end

  #
  # Renders the component, all of the items, and any user-provided content.
  #
  def call
    part(:component) do
      items.each do |item|
        concat(item)
      end

      concat(content) if content?
    end
  end
end
