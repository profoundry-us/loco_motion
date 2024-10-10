def init
  super
  sections.place(:slots).before(:method_summary)
end
