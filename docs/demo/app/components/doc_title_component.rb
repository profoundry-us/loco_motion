class DocTitleComponent < ApplicationComponent
  include ViewComponent::SlotableDefault

  define_parts :title, :title_wrapper, :description, :actions

  # Utilizes the new slot defaults API (below) to render a default API button
  renders_one :api_button, Daisy::Actions::ButtonComponent

  attr_reader :simple_title

  def initialize(*args, **kws)
    super

    @simple_title = config_option(:title)
    @comp = config_option(:comp)
  end

  def before_render
    add_stimulus_controller(:component, "doc-title")

    setup_title
    setup_description
  end

  def setup_title
    set_tag_name(:title, :h2)
    add_css(:title_wrapper, "flex items-center justify-between")
    add_css(:title, "text-2xl font-bold")
    add_css(:actions, "flex items-center gap-x-4")
  end

  def setup_description
    add_css(:description, "prose lg:prose-lg")
  end

  def default_api_button
    return nil unless api_url

    Daisy::Actions::ButtonComponent.new(
      title: "API Docs",
      href: api_url,
      target: "_blank",
      css: "btn-xs btn-info btn-outline px-5 rounded-full hover:text-base-100!",
      right_icon: "arrow-top-right-on-square",
      right_icon_css: "w-4 h-4",
    )
  end

  def api_url
    return nil unless @comp

    comp_path = @comp.titleize.gsub(" ", "")

    "#{Rails.configuration.api_docs_host}/#{comp_path}.html"
  end
end
