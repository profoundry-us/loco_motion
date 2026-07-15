# frozen_string_literal: true

module LocoMotion
  module Patches
    module ViewComponent
      #
      # Monkey patches `ViewComponent::SlotableDefault` so `get_slot` forces the
      # component's `content` block to run first — any slots the block sets need
      # to be registered before `get_slot` can correctly decide whether to fall
      # back to a slot's default value.
      #
      module SlotableDefaultPatch
        # Force `content` to run first so any slots it sets get registered
        # before deciding whether to fall back to this slot's default value.
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
