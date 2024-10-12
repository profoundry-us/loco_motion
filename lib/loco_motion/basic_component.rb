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

end
