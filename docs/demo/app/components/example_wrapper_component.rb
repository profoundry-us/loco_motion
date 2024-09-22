class ExampleWrapperComponent < LocoMotion.configuration.base_component_class
  define_parts :title, :example, :pre, :code

  attr_reader :simple_title, :skip_cache, :code

  renders_one :description

  def initialize(*args, **kws)
    super

    @simple_title = config_option(:title, "Example")

    @calling_file, @line_number = caller_locations(3, 1).first.to_s.split(" ").first.split(":")
  end

  def before_render
    @skip_cache = config_option(:skip_cache, params[:skip_cache].present? || false)

    setup_component
    setup_title
    setup_example
    setup_code_parts
    setup_code_block
  end

  def setup_component
    add_stimulus_controller(:component, "active-tab")
    add_css(:component, "mt-8")
  end

  def setup_title
    set_tag_name(:title, :h1)
    add_css(:title, "mb-2 text-xl text-black font-bold")
  end

  def setup_example
    add_css(:example, "flex items-center justify-center")
  end

  def setup_code_parts
    set_tag_name(:pre, :pre)
    add_css(:pre, "overflow-x-auto")

    set_tag_name(:code, :code)
    add_css(:code, "rounded-lg language-haml")
    add_stimulus_controller(:code, "highlight-code")
  end

  def setup_code_block
    file_lines = Rails.cache.fetch(@calling_file, force: @skip_cache) { File.readlines(@calling_file) }

    # Initialize some of or empty variables
    @code = []
    skip_description_indent = nil

    # Start one line "early" because line numbers don't start at 0
    start_line = @line_number.to_i - 1
    start_indent = file_lines[start_line].match(/^\s*/)[0].length
    current_line = start_line

    # Track the number of indents to remove extra whitespace. We add 1 because
    # the example is always indented inside of the doc_example block.
    num_indent = (start_indent / 2) + 1

    # Setup a proc to add lines to the code block since we do it in different
    # places in the loop
    add_line = Proc.new { |line, indent| @code << line.sub("  " * indent, "") }

    # Iterate over the lines of the file
    while current_line < file_lines.length
      # Grab the current line
      current_file_line = file_lines[current_line]

      # If we only have whitespace, add it and move on
      if current_file_line.match(/^\s*$/)
        add_line.call(current_file_line, num_indent)

        current_line += 1
        next
      end

      # Break out early if we reach the end of the example (based on indentation
      # which works because we're using HAML)
      current_indent = current_file_line.match(/^\s*/)[0].length
      break if current_line > start_line && current_indent <= start_indent

      # Skip the doc_example line
      if current_file_line.match(/doc_example/)
        current_line += 1
        next
      end

      # Skip the description line now, and setup to skip the whole block on the
      # next run / line
      if current_file_line.match(/doc.with_description/)
        skip_description_indent = current_indent
        current_line += 1
        next
      end

      # Skip the description block
      if skip_description_indent.present?
        if current_indent <= skip_description_indent
          skip_description_indent = nil

          # When we reset the skip_description_indent, it means this line of
          # code should be displayed
          add_line.call(current_file_line, num_indent)
        end
      else
        # Add our line to the code block
        add_line.call(current_file_line, num_indent)
      end

      # And increment the line number
      current_line += 1
    end
  end

  def tab_content_css
    "tab-content border-base-300 rounded-box overflow-x-auto"
  end

  def background_pattern
    {
      style: "background-size: 8px 8px; background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAADxJREFUKFNjZCAOGDMSoc6YgYHhLCGFYEUgw/AphCvCpxBFES6FGIqwKcSqCF0hTkXICvEqgikkqAikEAC4pQk++Il8LgAAAABJRU5ErkJggg==)"
    }
  end
end
