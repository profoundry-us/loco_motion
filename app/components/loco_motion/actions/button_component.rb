# woot
class LocoMotion::Actions::ButtonComponent < LocoMotion.configuration.base_component_class
  set_component_name :btn

  define_sizes :xs, :sm, :md, :lg
  define_variants :neutral, :primary, :secondary, :accent
  define_variants :info, :success, :warning, :error
  define_variants :ghost, :link, :outline, :active, :disabled
  define_variants :glass, :no_animation

  def initialize(*args, **kws, &block)
    super

    @simple_title = config_option(:title, "Submit")
  end
end

# Pros and Cons of using sizes / variants
#
# Pros
#  - Well-defined, can document
#  - Can use Ruby to specify size / variant
#    size: :xl, variant: :primary
#  - Can generate an error / warning if you're using an unknown variant
#  - With custom components, variants make it easy to add lots of CSS at once
#    Maybe users could generate CSS like DaisyUI to fix this?
#
# Cons
#  - Already defined / documented in DaisyUI
#  - Can use CSS which is shorter?
#    css: 'btn-xl btn-primary'
#  - Doing multiple variants like primary and outline might be tricky
#  - Must figure out how to generate classes so Tailwind picks them up (maybe a JS plugin?)
#  - Would be difficult to only include necessary classes; easier to do everything even if unused
#
# Decision
#
# Build out variants / sizes support for custom components, but DaisyUI components
# should use CSS since it's already defined.
#
# We should rename the components/loco_motion directory to components/daisy so
# we can better support other components if we want to (Bootstrap, etc).
