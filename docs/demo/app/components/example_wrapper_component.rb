class ExampleWrapperComponent < LocoMotion.configuration.base_component_class
  def initialize(*args, **kws)
    super

    @title = config_option(:title, "Example")

    @calling_file, @line_number = caller_locations(3, 1).first.to_s.split(" ").first.split(":")
  end

  def before_render
    File.open(@calling_file, 'r') do |file|
      @file_lines = file.readlines
    end

    @code = []

    start_line = @line_number.to_i - 1
    start_indent = @file_lines[start_line].match(/^\s*/)[0].length
    current_line = start_line

    while current_line < @file_lines.length - 1
      @code << @file_lines[current_line]

      current_line += 1
      current_indent = @file_lines[current_line].match(/^\s*/)[0].length

      break if current_indent <= start_indent
    end
  end

  def call
    part(:component) do
      concat(content_tag(:h1, class: "mb-2 text-xl text-black font-bold") { @title })
      concat(content_tag(:div) { content })
      concat(
        # TODO: Use a very simple collapse instead of accordion
        content_tag(:div, class: "mt-4 collapse collapse-arrow bg-gray-100") do
          concat(tag(:input, type: "checkbox", class: ""))
          concat(content_tag(:div, class: "collapse-title italic") { "View Code" })
          concat(content_tag(:pre, class: "collapse-content overflow-x-auto") do
            content_tag(:code, class: "rounded-lg language-haml") { @code.join }
          end)
        end
      )
    end
  end
end
