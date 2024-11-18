class ExampleWrapperComponent < ApplicationComponent
  define_parts :title, :template, :example, :pre, :code

  attr_reader :simple_title, :skip_cache, :code, :allow_reset

  renders_one :description

  def initialize(*args, **kws)
    super

    @simple_title = config_option(:title, nil)
    @tab_content_css = config_option(:tab_content_css, "")
    @allow_reset = config_option(:allow_reset, false)

    @calling_file, @line_number = caller_locations(3, 1).first.to_s.split(" ").first.split(":")
  end

  def before_render
    @skip_cache = config_option(:skip_cache, params[:skip_cache].present? || false)

    setup_component
    setup_title
    setup_template
    setup_example
    setup_code_parts
    setup_code_block
  end

  def setup_component
    add_stimulus_controller(:component, "example-wrapper")
    add_stimulus_controller(:component, "active-tab")
    add_css(:component, "mt-8")
  end

  def setup_title
    set_tag_name(:title, :h1)
    add_css(:title, "mb-2 text-xl text-base font-bold")
  end

  def setup_template
    set_tag_name(:template, :template)
    add_html(:template, { data: { "example-wrapper-target": "template" } })
  end

  def setup_example
    add_css(:example, "flex items-center justify-center")
    add_html(:example, { data: { "example-wrapper-target": "preview" } })
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
    "tab-content border-base-300 rounded-box overflow-x-auto #{@tab_content_css}"
  end

  def background_pattern
    {
      # Simple Lines
      # style: "background-size: 8px 8px; background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAADxJREFUKFNjZCAOGDMSoc6YgYHhLCGFYEUgw/AphCvCpxBFES6FGIqwKcSqCF0hTkXICvEqgikkqAikEAC4pQk++Il8LgAAAABJRU5ErkJggg==)"

      # Hexagons
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='29' height='50.115' patternTransform='scale(1) rotate(20)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 0%, 100%, 0)'/><path d='M14.498 16.858L0 8.488.002-8.257l14.5-8.374L29-8.26l-.002 16.745zm0 50.06L0 58.548l.002-16.745 14.5-8.373L29 41.8l-.002 16.744zM28.996 41.8l-14.498-8.37.002-16.744L29 8.312l14.498 8.37-.002 16.745zm-29 0l-14.498-8.37.002-16.744L0 8.312l14.498 8.37-.002 16.745z'  stroke-width='1' stroke='hsla(0, 0%, 0%, 0.07)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Waves
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='120' height='20' patternTransform='scale(1) rotate(165)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 6.70%, 17.60%, 0)'/><path d='M-50.129 12.685C-33.346 12.358-16.786 4.918 0 5c16.787.082 43.213 10 60 10s43.213-9.918 60-10c16.786-.082 33.346 7.358 50.129 7.685'  stroke-width='1' stroke='hsla(0, 0%, 0%, 0.07)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Lines
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='20' height='20' patternTransform='scale(1) rotate(30)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(0, 0%, 0%, 0)'/><path d='M0 10h20z'   stroke-width='2.5' stroke='hsla(0, 0%, 0%, 0.07)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Memphis Colors
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='70' height='70' patternTransform='scale(2) rotate(0)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 0%, 100%, 1)'/><path d='M-4.8 4.44L4 16.59 16.14 7.8M32 30.54l-13.23 7.07 7.06 13.23M-9 38.04l-3.81 14.5 14.5 3.81M65.22 4.44L74 16.59 86.15 7.8M61 38.04l-3.81 14.5 14.5 3.81'  stroke-linecap='square' stroke-width='1' stroke='hsla(296.19, 97.59%, 48.40%, 0.35)' fill='none'/><path d='M59.71 62.88v3h3M4.84 25.54L2.87 27.8l2.26 1.97m7.65 16.4l-2.21-2.03-2.03 2.21m29.26 7.13l.56 2.95 2.95-.55'  stroke-linecap='square' stroke-width='1' stroke='hsla(4.1, 89.60%, 58.40%, 1)' fill='none'/><path d='M58.98 27.57l-2.35-10.74-10.75 2.36M31.98-4.87l2.74 10.65 10.65-2.73M31.98 65.13l2.74 10.66 10.65-2.74'  stroke-linecap='square' stroke-width='1' stroke='hsla(186.8, 100%, 41.6%, 1)' fill='none'/><path d='M8.42 62.57l6.4 2.82 2.82-6.41m33.13-15.24l-4.86-5.03-5.03 4.86m-14-19.64l4.84-5.06-5.06-4.84'  stroke-linecap='square' stroke-width='1' stroke='hsla(258.5, 59.40%, 59.4%, 1)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Bricks
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='60' height='30' patternTransform='scale(1) rotate(45)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(0, 0%, 0%, 0.08)'/><path d='M1-6.5v13h28v-13H1zm15 15v13h28v-13H16zm-15 15v13h28v-13H1z'  stroke-width='1' stroke='none' fill='hsla(0, 0%, 0%, 0)'/><path d='M31-6.5v13h28v-13H31zm-45 15v13h28v-13h-28zm60 0v13h28v-13H46zm-15 15v13h28v-13H31z'  stroke-width='1' stroke='none' fill='hsla(0, 0%, 0%, 0.13)'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Better Bricks
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='30' height='30' patternTransform='scale(1) rotate(0)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 0%, 100%, 0)'/><path d='M0 22.5h30v15H0zm15-15h30v15H15m-30-15h30v15h-30zm15-15h30v15H0z'  stroke-width='1' stroke='hsla(0, 0%, 0%, 0.07)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Waves Smaller
      style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='40' height='20' patternTransform='scale(1) rotate(45)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 0%, 100%, 0)'/><path d='M-4.798 13.573C-3.149 12.533-1.446 11.306 0 10c2.812-2.758 6.18-4.974 10-5 4.183.336 7.193 2.456 10 5 2.86 2.687 6.216 4.952 10 5 4.185-.315 7.35-2.48 10-5 1.452-1.386 3.107-3.085 4.793-4.176'  stroke-width='1' stroke='hsla(0, 0%, 0%, 0.07)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Railroad
      # style: %(background-image: url("data:image/svg+xml,<svg id='patternId' width='100%' height='100%' xmlns='http://www.w3.org/2000/svg'><defs><pattern id='a' patternUnits='userSpaceOnUse' width='40' height='30' patternTransform='scale(1) rotate(135)'><rect x='0' y='0' width='100%' height='100%' fill='hsla(240, 0%, 100%, 0)'/><path d='M27 22.545H3M5.5 0v30M27 7.545H3M24.5 0v30' transform='translate(5,0)' stroke-linejoin='round' stroke-linecap='round' stroke-width='0.5' stroke='hsla(0, 0%, 0%, 0.05)' fill='none'/></pattern></defs><rect width='800%' height='800%' transform='translate(0,0)' fill='url(%23a)'/></svg>"))

      # Empty
      # style: %()
    }
  end

  def active_tab_html
    { data: { "active-tab-target": "tab", action: "active-tab#activate" }}
  end

  def reset_html
    { data: { action: "example-wrapper#reset" } }
  end

end
