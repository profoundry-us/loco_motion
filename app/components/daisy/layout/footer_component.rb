#
# The footer component is a simple container for the footer of a page. It can be
# used to hold copyright information, links to other pages, or any other
# information that should be displayed at the bottom of a page.
#
# @loco_example Basic Usage
#   = daisy_footer(css: "bg-neutral text-neutral-content") do
#     %nav
#       = link_to "Home", root_path
#
# @loco_example With Text
#   = daisy_footer(css: "bg-neutral text-neutral-content p-10 text-center text-sm") do
#     Copyright &copy; 2024
#
class Daisy::Layout::FooterComponent < LocoMotion::BaseComponent
  #
  # Add the `footer` CSS class to the component and set the tag name to `footer`.
  #
  def before_render
    add_css(:component, "footer")
    set_tag_name(:component, :footer)
  end

  #
  # Render the component and it's content (inline).
  #
  def call
    part(:component) { content }
  end
end
