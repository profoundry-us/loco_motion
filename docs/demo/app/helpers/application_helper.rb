module ApplicationHelper
  def doc_code(*args, **kws, &block)
    render(DocCodeComponent.new(*args, **kws), &block)
  end

  def doc_code_tab(*args, **kws, &block)
    render(DocCodeTabComponent.new(*args, **kws), &block)
  end

  def doc_example(*args, **kws, &block)
    render(ExampleWrapperComponent.new(*args, **kws), &block)
  end

  def doc_note(*args, **kws, &block)
    render(DocNoteComponent.new(*args, **kws), &block)
  end

  def doc_title(*args, **kws, &block)
    render(DocTitleComponent.new(*args, **kws), &block)
  end
end
