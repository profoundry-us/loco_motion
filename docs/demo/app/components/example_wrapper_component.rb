class ExampleWrapperComponent < LocoMotion.configuration.base_component_class
  define_parts :title, :example, :pre, :code

  attr_reader :simple_title, :skip_cache, :code

  def initialize(*args, **kws)
    super

    @simple_title = config_option(:title, "Example")

    @calling_file, @line_number = caller_locations(3, 1).first.to_s.split(" ").first.split(":")
  end

  def before_render
    @skip_cache = config_option(:skip_cache, params[:skip_cache].present? || false)

    setup_component
    setup_title
    setup_code_parts
    setup_code_block
  end

  def setup_component
    add_css(:component, "mt-8")
  end

  def setup_title
    set_tag_name(:title, :h1)
    add_css(:title, "mb-2 text-xl text-black font-bold")
  end

  def setup_code_parts
    set_tag_name(:pre, :pre)
    add_css(:pre, "overflow-x-auto")

    set_tag_name(:code, :code)
    add_css(:code, "mt-4 rounded-lg language-haml")
  end

  def setup_code_block
    file_lines = Rails.cache.fetch(@calling_file, force: @skip_cache) { File.readlines(@calling_file) }

    @code = []

    start_line = @line_number.to_i - 1
    start_indent = file_lines[start_line].match(/^\s*/)[0].length
    current_line = start_line

    while current_line < file_lines.length
      # Break out early if we reach the end of the example (based on indentation
      # which works because we're using HAML)
      current_indent = file_lines[current_line].match(/^\s*/)[0].length
      break if current_line > start_line && current_indent <= start_indent

      # Otherwise we can add our line to the code block
      @code << file_lines[current_line]

      # And increment the line number
      current_line += 1
    end
  end
end
