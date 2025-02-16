class Daisy::Mockup::CodeComponent < LocoMotion::BaseComponent

  class Daisy::Mockup::CodeLineComponent < LocoMotion::BaseComponent
    define_parts :code

    def initialize(*args, **kws, &block)
      super

      @prefix = config_option(:prefix)
    end

    def before_render
      set_tag_name(:component, :pre)
      set_tag_name(:code, :code)

      add_html(:component, { "data-prefix": @prefix }) if @prefix
    end

    def call
      part(:component) do
        part(:code) do
          content
        end
      end
    end
  end

  define_parts :pre, :code

  renders_many :lines, Daisy::Mockup::CodeLineComponent

  def initialize(*args, **kws, &block)
    super

    @prefix = config_option(:prefix)
  end

  def before_render
    add_css(:component, "mockup-code")

    set_tag_name(:pre, :pre)
    set_tag_name(:code, :code)

    add_html(:pre, { "data-prefix": @prefix }) if @prefix

    # If the prefix is blank, add some left margin and hide the :before
    # pseudo-element used for the prefix
    add_css(:pre, "before:!hidden ml-6") if @prefix.blank?
  end

  def call
    part(:component) do
      if lines.any?
        # If there are lines, we render only them
        lines.each { |line| concat(line) }
      else
        # Otherwise, we render the content in a fake line
        part(:pre) do
          part(:code) do
            concat(content)
          end
        end
      end
    end
  end

end

