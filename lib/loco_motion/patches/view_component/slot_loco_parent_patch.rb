# Monkey patch ViewComponent::Slot to save the parent component

module LocoMotion
  module Patches
    module ViewComponent
      module SlotPatch
        # Set the loco parent any time the instance changes
        def __vc_component_instance=(instance)
          # Set the parent
          instance.set_loco_parent(@parent) unless instance.loco_parent.present?

          # Call the original implementation
          super
        end
      end
    end
  end
end

# Apply the patch
::ViewComponent::Slot.prepend(LocoMotion::Patches::ViewComponent::SlotPatch)
