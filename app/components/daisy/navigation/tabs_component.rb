#
# Creates a tabbed navigation component that can be used either as links or radio
# buttons with associated content.
#
# @note When using radio button tabs, the titles must be simple strings and cannot
#   contain HTML elements or icons.
#
# @slot tabs+ {Daisy::Navigation::TabsComponent::TabComponent} The individual
#   tabs to display.
#
# @example Basic tabs with links
#   = daisy_tabs(css: "tabs-border") do |tabs|
#     - tabs.with_tab(title: "Home", active: true)
#     - tabs.with_tab(title: "Click Me", html: { onclick: "alert('Clicked!')" })
#     - tabs.with_tab(title: "Google", href: "https://google.com", target: "_blank")
#
# @example Radio button tabs with content
#   = daisy_tabs(css: "tabs-lift", radio: true) do |tabs|
#     - tabs.with_tab(title: "Tab 1", checked: true) do
#       %p Tab 1 content
#     - tabs.with_tab(title: "Tab 2") do
#       %p Tab 2 content
#
# @example Tabs with custom titles and content
#   = daisy_tabs(css: "tabs-lift") do |tabs|
#     - tabs.with_tab do |tab|
#       - tab.with_title do
#         .flex.gap-2
#           = hero_icon("home")
#           Home
#       - tab.with_custom_content(css: "tab-content p-4") do
#         %p Welcome home!
#
# @example Tabs with different sizes
#   = daisy_tabs(css: "tabs-border tabs-xl") do |tabs|
#     - tabs.with_tab(title: "Extra Large Tab", active: true)
#     - tabs.with_tab(title: "Another Tab")
#
# @example Tabs with different sizes
#   = daisy_tabs(css: "tabs-border tabs-lg") do |tabs|
#     - tabs.with_tab(title: "Large Tab", active: true)
#     - tabs.with_tab(title: "Another Tab")
#
class Daisy::Navigation::TabsComponent < LocoMotion::BaseComponent

  #
  # A tab within a TabsComponent that can be either a link or a radio button.
  #
  # @part content_wrapper The wrapper for the tab's content when not using
  #   custom content.
  #
  # @slot title The title content for the tab. Only used if no `title` option
  #   is provided.
  #
  # @slot custom_content Custom content to be rendered after the tab. Use this
  #   instead of the block content for complete control over the content's HTML.
  #
  # @example Basic tab with title
  #   = tabs.with_tab(title: "Home")
  #
  # @example Tab with custom title
  #   = tabs.with_tab do |tab|
  #     - tab.with_title do
  #       .flex.gap-2
  #         = hero_icon("home")
  #         Home
  #
  # @example Tab with content
  #   = tabs.with_tab(title: "Content") do
  #     %p This is the tab's content
  #
  # @example Tab with custom content
  #   = tabs.with_tab do |tab|
  #     - tab.with_custom_content(css: "tab-content p-4") do
  #       %p Custom content with custom wrapper
  #
  class TabComponent < LocoMotion::BasicComponent
    define_parts :content_wrapper

    renders_one :title
    renders_one :custom_content

    attr_reader :active, :simple_title

    # Create a new instance of the TabComponent.
    #
    # @param args [Array] Not used.
    #
    # @param kws [Hash] The keyword arguments for the component.
    #
    # @option kws title [String] The text to display in the tab.
    #
    # @option kws active [Boolean] Whether this tab is active (default: false).
    #
    # @option kws checked [Boolean] Whether this tab is checked (default: false).
    #
    # @option kws disabled [Boolean] Whether this tab is disabled (default: false).
    #
    # @option kws href [String] The URL to visit when the tab is clicked.
    #
    # @option kws target [String] The target attribute for the tab (e.g., "_blank").
    #
    # @option kws value [String] The value attribute when using radio buttons.
    #
    # @option kws css [String] Additional CSS classes for styling. Common
    #   options include:
    #   - Size: `tab-lg`, `tab-md` (default), `tab-sm`, `tab-xs`
    #   - Width: `w-full`, `!w-14`
    #   - Cursor: `cursor-pointer`, `!cursor-auto`
    #
    def initialize(*args, **kws, &block)
      super

      @active       = config_option(:active, false)
      @checked      = config_option(:checked, false)
      @disabled     = config_option(:disabled, false)
      @href         = config_option(:href)
      @simple_title = config_option(:title)
      @target       = config_option(:target)
      @value        = config_option(:value)
    end

    def before_render
      # Reset the name to the config option or the parent name if available
      @name = config_option(:name, loco_parent&.name)

      if loco_parent&.radio?
        setup_radio_button
      else
        setup_component
      end

      setup_content_wrapper unless custom_content?
    end

    def setup_component
      set_tag_name(:component, :a)
      add_css(:component, "tab")
      add_css(:component, "tab-active") if @active || @checked
      add_html(:component, { role: "tab", href: @href, target: @target, "aria-label": @simple_title })
      add_html(:component, { disabled: @disabled }) if @disabled
    end

    def setup_radio_button
      set_tag_name(:component, :input)
      add_css(:component, "tab")
      add_html(:component, {
        type: "radio",
        role: "tab",
        "aria-label": @simple_title,
        name: @name,
        value: @value,
        checked: @active || @checked
      })
      add_html(:component, { disabled: @disabled }) if @disabled
    end

    def setup_content_wrapper
      add_css(:content_wrapper, "tab-content")
      add_html(:content_wrapper, { role: "tabpanel" })
    end

    def call
      # Not sure why we need these, but this forces the rendering below to
      # include the content blocks passed to each slot.
      # title.to_s if title?
      # custom_content.to_s if custom_content?

      capture do
        if loco_parent&.radio?
          concat(part(:component))
        else
          concat(part(:component) { concat(title? ? title : @simple_title) })
        end

        concat(part(:content_wrapper) { content }) if content? && content
        concat(custom_content) if custom_content?
      end
    end
  end

  renders_many :tabs, TabComponent

  attr_reader :name, :radio

  # Create a new instance of the TabsComponent.
  #
  # @param args [Array] Not used.
  #
  # @param kws [Hash] The keyword arguments for the component.
  #
  # @option kws name [String] The name attribute for radio button tabs
  #   (default: auto-generated UUID).
  #
  # @option kws radio [Boolean] Whether to use radio buttons instead of links
  #   (default: false).
  #
  # @option kws css [String] Additional CSS classes for styling. Common
  #   options include:
  #   - Style: `tabs-border`, `tabs-lift`
  #   - Size: `tabs-xl`, `tabs-lg`, `tabs-md` (default), `tabs-sm`, `tabs-xs`
  #   - Width: `w-full`, `w-[500px]`
  #
  def initialize(*args, **kws, &block)
    super

    @name = config_option(:name, "tabs-#{SecureRandom.uuid}")
    @radio = config_option(:radio, false)
  end

  def before_render
    add_css(:component, "tabs")
    add_html(:component, { role: "tablist" })
  end

  def radio?
    radio
  end

end
