module ApplicationHelper
  def doc_title(*args, **kws, &block)
    render(DocTitleComponent.new(*args, **kws), &block)
  end

  def doc_example(*args, **kws, &block)
    render(ExampleWrapperComponent.new(*args, **kws), &block)
  end
end
