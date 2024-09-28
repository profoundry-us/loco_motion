templates_path = Pathname.new(__dir__).join('templates')

puts "\n\n *** LOADING YARD LOCO: #{templates_path}\n\n"
YARD::Templates::Engine.register_template_path templates_path
# YARD::Parser::SourceParser.parser_type = :ruby18

# tags = [
  YARD::Tags::Library.define_tag("Slots", :slot, :with_name)
# ]
# YARD::Tags::Library.visible_tags |= tags

# class MyHandler < YARD::Handlers::Ruby::Base
#   handles :class

#   process do
#     puts "\n\n *** PATHNAME: #{Pathname.new(__FILE__).join('templates')}\n\n"
#   end
# end

def htmlify_inline(text)
  htmlify(text).gsub(/^<p>|<\/p>$/, '')
end
