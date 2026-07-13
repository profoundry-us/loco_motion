# frozen_string_literal: true

# Renders the "checklist" sections that close out several docs and guides: a
# stack of real (uncheckable-consequence-free) daisy_checkboxes whose trailing
# labels hold each step's description.
#
# Item content is rendered as Markdown (the same Redcarpet engine behind the
# `:markdown` HAML filter), so call sites can pass plain text with inline
# code spans and links.
#
# The wrapper opts the DaisyUI labels out of their `nowrap` default so long
# descriptions wrap on phones, top-aligns each checkbox with the first line of
# its text, and lets unbreakable inline-code tokens (rake tasks, fully
# qualified class names) break mid-token instead of clipping at the viewport
# edge.
class DocChecklistComponent < ApplicationComponent
  # A single checklist entry: a named checkbox whose trailing label renders
  # the item's block content as Markdown.
  class ItemComponent < ApplicationComponent
    def initialize(*args, **kws)
      super

      @name = config_option(:name)
      @id = config_option(:id, @name)
    end

    def call
      daisy_checkbox(name: @name, id: @id) do |checkbox|
        checkbox.with_trailing { render_markdown(content) }
      end
    end

    private

    def render_markdown(text)
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text).html_safe
    end
  end

  renders_many :items, ItemComponent

  def before_render
    setup_component
  end

  def setup_component
    add_css(:component,
            "max-w-prose flex flex-col gap-4 " \
            "[&_.label]:items-start [&_.label]:whitespace-normal " \
            "[&_code]:wrap-anywhere")
  end
end
