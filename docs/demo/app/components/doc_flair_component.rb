# frozen_string_literal: true

# Positions a piece of decorative "flair" — a real LocoMotion component — over
# the home page and wires it into the `parallax` Stimulus controller. Two modes:
#
#   * parallax (default) — the hero cluster; each item drifts, spins, and fades
#     as the page scrolls.
#   * pop — flair in the lower sections; springs into view when scrolled near.
#
# It encapsulates the absolute positioning, `will-change`, and transition
# classes so the home template stays free of inline `style` attributes and the
# repeated wrapper markup. The wrapper does NOT swallow pointer events, so the
# real components inside it stay interactive.
class DocFlairComponent < ApplicationComponent
  def initialize(*args, **kws, &block)
    super

    @pos = config_option(:pos, "")
    @rot = config_option(:rot, 0)
    @show = config_option(:show, "md")
    @pop = config_option(:pop, false)
    @speed = config_option(:speed, 0.5)
    @drift = config_option(:drift, 0)
  end

  def before_render
    # NOTE: Rotation is intentionally NOT set as a CSS class here — the
    # `parallax` controller drives every item's transform (rotation included)
    # from the `rot` data attribute, both while scrolling and at rest. Adding an
    # interpolated `rotate-[Ndeg]` class would also be invisible to Tailwind's
    # class scanner, so it would never generate the CSS.
    # Use whole, literal class strings (never an interpolated breakpoint) so
    # Tailwind's source scanner actually sees `md:block` / `lg:block` and emits
    # them — an interpolated `#{@show}:block` is invisible to the scanner.
    add_css(:component, "absolute z-[5] will-change-[transform,opacity]")
    add_css(:component, @show.to_s == "lg" ? "hidden lg:block" : "hidden md:block")
    add_css(:component, @pos)

    if @pop
      # The controller drives `transform` directly, so the resting/hidden state
      # is expressed as an arbitrary `transform` utility (not `translate-*` /
      # `scale-*`, which map to the separate `translate` / `scale` properties in
      # Tailwind v4 and would fight the controller's inline `transform`).
      add_css(:component, "opacity-0 [transform:translateY(46px)_scale(.4)] " \
                          "transition-[transform,opacity] duration-[.6s] " \
                          "ease-[cubic-bezier(.34,1.56,.64,1)]")
      add_html(:component, { data: { pop: true, pop_rot: @rot } })
    else
      add_html(:component, { data: {
                 parallax_speed: @speed, parallax_drift: @drift, parallax_rot: @rot
               } })
    end
  end

  def call
    part(:component) { content }
  end
end
