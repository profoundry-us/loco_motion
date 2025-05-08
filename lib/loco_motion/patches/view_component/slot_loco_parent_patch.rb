# Monkey patch ViewComponent::Slot to save the parent component

module LocoMotion
  module Patches
    module ViewComponent
      module SlotPatch

        # Set the loco parent any time the instance changes
        def __vc_component_instance=(instance)
          # Call the original implementation
          super

          # And set the Loco parent
          set_loco_parent
        end

        def to_s
          set_loco_parent

          super
        end

        def set_loco_parent(parent = @parent)
          return if parent.nil?
          return if @__vc_component_instance.loco_parent.present?

          @__vc_component_instance.set_loco_parent(parent)
        end

      end
    end
  end
end

# Apply the patch
::ViewComponent::Slot.prepend(LocoMotion::Patches::ViewComponent::SlotPatch)
