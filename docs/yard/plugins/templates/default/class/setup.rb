def init
  super
  sections.place(:loco_examples).before(:constant_summary)
  sections.place(:slots).before(:loco_examples)
  sections.place(:parts).before(:slots)
end
