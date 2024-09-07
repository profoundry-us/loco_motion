#
# The BasicComponent class is used for all slots that don't provide a component
# so that users can pass in all of the same CSS and HTML options that a standard
# component would have.
#
class LocoMotion::BasicComponent < LocoMotion.configuration.base_component_class

  def call
    part(:component) do
      content
    end
  end

  def self.name
    "BasicComponent"
  end

  #
  # You can also build a BasicComponent that just adds some default CSS classes.
  #
  def self.build(tag_name: :div, css: "", html: {}, &block)
    klass = Class.new(LocoMotion::BasicComponent)

    klass.class_eval(&block) if block_given?

    klass.class_eval do
      old_before_render = instance_method(:before_render)

      define_method(:before_render) do
        old_before_render.bind(self).call

        set_tag_name(:component, tag_name)
        add_css(:component, css)
        add_html(:component, html)
      end
    end

    klass
  end

end
