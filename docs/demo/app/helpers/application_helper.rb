module ApplicationHelper
  def doc_example(*args, **kws, &block)
    render(ExampleWrapperComponent.new(*args, **kws), &block)
  end
end
