# Monkey patch ViewComponent::SlotableDefault to modify get_slot behavior

module LocoMotion
  module Patches
    module ViewComponent
      module SlotableDefaultPatch
        # Override get_slot method
        def get_slot(slot_name)
          # ensure content is loaded so slots will be defined
          content unless content_evaluated?

          # Call the original implementation
          super
        end
      end
    end
  end
end

# Apply the patch
::ViewComponent::SlotableDefault.prepend(LocoMotion::Patches::ViewComponent::SlotableDefaultPatch)
