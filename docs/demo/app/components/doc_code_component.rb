class DocCodeComponent < ApplicationComponent

  define_parts :pre, :code

  def initialize(*args, **kws, &block)
    super

    @language = config_option(:language, "haml")
  end

  def before_render
    add_stimulus_controller(:code, "highlight-code")
    add_css(:code, "hljs rounded-lg language-#{@language}")

    set_tag_name(:code, :code)
    set_tag_name(:pre, :pre)
  end

  #
  # Again, use `call` so we can avoid extra whitespace with the template file.
  #
  def call
    part(:component) do
      part(:pre) do
        part(:code) do
          content
        end
      end
    end
  end

end
