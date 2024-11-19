class Daisy::Navigation::BottomNavComponent < LocoMotion::BaseComponent

  class Daisy::Navigation::BottomNavSectionComponent < LocoMotion::BaseComponent

    define_parts :icon, :title

    def initialize(*args, **kws, &block)
      super

      @icon = config_option(:icon)
      @icon_variant = config_option(:icon_variant, :outline)
      @title = config_option(:title)
      @href = config_option(:href)
      @active = config_option(:active, false)
    end

    def before_render
      if @href
        set_tag_name(:component, :a)
        add_html(:component, href: @href)
      else
        set_tag_name(:component, :button)
      end

      add_css(:component, "active") if @active

      add_css(:icon, "[:where(&)]:size-6")

      set_tag_name(:title, :span)
      add_css(:title, "btm-nav-label")
    end

    def call
      part(:component) do
        concat(hero_icon(@icon, variant: @icon_variant, html: rendered_html(:icon))) if @icon
        concat(part(:title) { @title }) if @title
        concat(content)
      end
    end

  end

  renders_many :sections, Daisy::Navigation::BottomNavSectionComponent

  def before_render
    add_css(:component, "btm-nav")
  end

  def call
    part(:component) do
      sections.each do |section|
        concat(section)
      end

      concat(content)
    end
  end

end
