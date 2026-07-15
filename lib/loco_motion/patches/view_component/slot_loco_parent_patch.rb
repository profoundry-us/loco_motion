# frozen_string_literal: true

module LocoMotion
  module Patches
    module ViewComponent
      #
      # Monkey patches `ViewComponent::Slot` so the LocoMotion component it
      # wraps can reach its parent — `ViewComponent::Slot` has no built-in way
      # to do that on its own. Slot-based components (tabs, accordion, drawer,
      # and others) depend on this patch to inherit config and state from
      # their parent via `loco_parent`.
      #
      module SlotPatch
        # Set the loco parent any time the instance changes
        def __vc_component_instance=(instance)
          # Call the original implementation
          super

          # And set the Loco parent
          set_loco_parent
        end

        # Set the loco parent again right before the slot renders.
        def to_s
          set_loco_parent

          super
        end

        # Guard-clause logic the overrides above rely on: sets the parent on the
        # wrapped instance, skipping when the parent is missing, no instance is
        # set yet, or the instance already has a loco parent.
        def set_loco_parent(parent = @parent)
          return if parent.nil?
          return if @__vc_component_instance.nil?
          return if @__vc_component_instance.loco_parent.present?

          @__vc_component_instance.set_loco_parent(parent)
        end
      end
    end
  end
end

# Apply the patch
::ViewComponent::Slot.prepend(LocoMotion::Patches::ViewComponent::SlotPatch)
