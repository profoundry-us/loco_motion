templates_path = Pathname.new(__dir__).join('templates')

YARD::Templates::Engine.register_template_path templates_path

YARD::Tags::Library.define_tag("Parts", :part, :with_types_and_name)
YARD::Tags::Library.define_tag("Slots", :slot, :with_types_and_name)
YARD::Tags::Library.define_tag("Loco Examples", :loco_example)

def htmlify_inline(text)
  htmlify(text).gsub(/^<p>|<\/p>$/, '')
end

def typify(text)
  text.gsub(/`([^`]+)`/, '<code>\1</code>')
end
