# Monkey patch ViewComponent::Slot to save the parent component

module LocoMotion
  module Patches
    module ViewComponent
      module SlotPatch
        # Override to_s method to save the parent component
        def to_s
          # Set the parent
          @__vc_component_instance.set_loco_parent(@parent) unless @__vc_component_instance.loco_parent.present?

          # Call the original implementation
          super
        end
      end
    end
  end
end

# Apply the patch
::ViewComponent::Slot.prepend(LocoMotion::Patches::ViewComponent::SlotPatch)
