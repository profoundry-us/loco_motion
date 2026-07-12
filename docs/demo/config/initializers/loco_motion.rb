# frozen_string_literal: true

LocoMotion.configure do |config|
  # Resolve icons strictly from the vendored set in every environment. The
  # dev-only cache fallback would quietly render icons we forgot to sync,
  # hiding the failure until CI (which runs in production mode). With the
  # fallback off, an unvendored icon raises immediately in development and
  # local Playwright runs — run `bin/rails loco_motion:icons:sync` and commit
  # the SVGs to fix.
  config.icon_dev_fallback = false

  # Icons referenced dynamically, so `loco_motion:icons:sync` cannot see them
  # by scanning source. Without these the treeshake would drop them and they
  # would 404 at render time. See the Install guide's "treeshaking" section.
  config.icon_safelist = %w[
    information-circle
    chat-bubble-oval-left-ellipsis
    ellipsis-horizontal-circle
    exclamation-triangle
    bars-2
    bars-3
    bars-4
    home/mini
    document/mini
    cube/mini
    squares-2x2/mini
  ]
end
