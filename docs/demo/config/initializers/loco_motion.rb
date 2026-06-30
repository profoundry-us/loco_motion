# frozen_string_literal: true

LocoMotion.configure do |config|
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
