module ApplicationHelper
  def full_page_title
    page_title = yield :page_title

    page_title ? page_title + " | LocoMotion" : "LocoMotion"
  end

  def doc_url(path)
    "#{Rails.configuration.api_docs_host}/#{path}.html"
  end

  def doc_code(*args, **kws, &block)
    render(DocCodeComponent.new(*args, **kws), &block)
  end

  def doc_code_tab(*args, **kws, &block)
    render(DocCodeTabComponent.new(*args, **kws), &block)
  end

  def doc_example(*args, **kws, &block)
    render(DocExampleComponent.new(*args, **kws), &block)
  end

  def doc_note(*args, **kws, &block)
    render(DocNoteComponent.new(*args, **kws), &block)
  end

  def doc_title(*args, **kws, &block)
    render(DocTitleComponent.new(*args, **kws), &block)
  end

  # Creates a link to a component example page with consistent styling
  #
  # @param text [String] The button text
  # @param component_class [String] The full component class name (e.g., "Daisy::DataInput::TextInputComponent")
  # @param size [String] The button size (default: "btn-xs")
  # @param html_options [Hash] Additional HTML options for the button
  # @return [String] HTML for the component link button
  def component_link(text, component_class, css: "btn-xs", **options)
    daisy_button(
      text,
      css: css,
      href: "/examples/#{component_class}",
      right_icon: "cube",
      right_icon_css: "size-4",
      **options
    )
  end
end
