class DocCodeComponent < ApplicationComponent

  define_parts :pre, :code

  def initialize(*args, **kws, &block)
    super

    @language = config_option(:language, "haml")
  end

  def before_render
    add_stimulus_controller(:code, "highlight-code")
    add_css(:code, "hljs !px-0 !py-2 language-#{@language}")

    set_tag_name(:code, :code)
    set_tag_name(:pre, :pre)
  end

end
