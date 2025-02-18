#
# The FooterComponent creates a responsive container for page footer content.
# Common use cases include:
# - Site navigation and sitemap links.
# - Copyright and legal information.
# - Contact details and social media links.
# - Newsletter signup forms.
#
# The component is responsive by default and will stack content on smaller
# screens.
#
# @loco_example Basic Navigation Footer
#   = daisy_footer(css: "bg-neutral text-neutral-content p-10") do
#     %nav
#       %h6.footer-title Company
#       = link_to "About", "/about", class: "link-hover"
#       = link_to "Contact", "/contact", class: "link-hover"
#       = link_to "Jobs", "/careers", class: "link-hover"
#
# @loco_example Multi-Column Footer
#   = daisy_footer(css: "bg-base-200 text-base-content p-10") do
#     %nav
#       %h6.footer-title Products
#       = link_to "Features", "#", class: "link-hover"
#       = link_to "Pricing", "#", class: "link-hover"
#
#     %nav
#       %h6.footer-title Support
#       = link_to "Documentation", "#", class: "link-hover"
#       = link_to "Help Center", "#", class: "link-hover"
#
# @loco_example Copyright Footer
#   = daisy_footer(css: "bg-neutral text-neutral-content p-4 text-center") do
#     %small
#       Copyright &copy; 2024 Company Name.
#       All rights reserved.
#
class Daisy::Layout::FooterComponent < LocoMotion::BaseComponent
  #
  # Creates a new Footer component.
  #
  # @param kws [Hash] Keyword arguments for customizing the footer.
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Background: `bg-neutral`, `bg-base-200`
  #   - Text color: `text-neutral-content`, `text-base-content`
  #   - Spacing: `p-4`, `p-10`
  #   - Layout: `text-center`, `grid grid-cols-2 gap-4`
  #
  def initialize(**kws)
    super
  end

  #
  # Sets up the component's CSS classes and HTML tag.
  #
  def before_render
    add_css(:component, "footer")
    set_tag_name(:component, :footer)
  end

  #
  # Renders the component and its content.
  #
  def call
    part(:component) { content }
  end
end
