# This is the Tabs component.
class Daisy::Navigation::TabsComponent < LocoMotion.configuration.base_component_class

  TabComponent = LocoMotion::BasicComponent.build do
    define_parts :content_wrapper

    renders_one :title
    renders_one :custom_content

    attr_reader :active

    # @return [String] Accessor for the `title` string passed via the component
    #   config.
    attr_reader :simple_title

    def initialize(*args, **kws, &block)
      super

      @active       = config_option(:active, false)
      @checked      = config_option(:checked, false)
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
    end

    def setup_radio_button
      set_tag_name(:component, :input)
      add_html(:component, {
        type: "radio",
        role: "tab",
        "aria-label": @simple_title,
        name: @name,
        value: @value,
        checked: @active || @checked
      })
      add_css(:component, "tab")
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
          # asdf if title?
          concat(part(:component) { concat(title? ? title : @simple_title) })
        end

        concat(part(:content_wrapper) { content }) if content? && content
        concat(custom_content) if custom_content?
      end
    end
  end

  renders_many :tabs, TabComponent

  attr_reader :name, :radio

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
