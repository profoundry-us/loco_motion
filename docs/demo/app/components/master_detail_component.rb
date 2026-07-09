# frozen_string_literal: true

# A small master/detail (list + detail) layout component, built for the
# "Building Components" guide to demonstrate parts, slots, and Stimulus.
#
# The master pane lists each record's title; clicking one shows that record's
# body in the detail pane. Selection is handled by the `master-detail` Stimulus
# controller.
#
# Following our own guideline, the component only ever sets *padding* on its
# parts — never outer margins. Where it sits and how much space surrounds it is
# up to the caller.
class MasterDetailComponent < ApplicationComponent
  # A single record. Supplies a `title` (shown in the master list) and a block
  # of body content (shown in the detail pane when selected).
  class RecordComponent < ApplicationComponent
    attr_reader :title

    def initialize(*args, **kws, &block)
      super

      @title = config_option(:title, "")
    end

    def call
      part(:component) { content }
    end
  end

  renders_many :records, RecordComponent

  define_parts :master, :detail

  def before_render
    add_css(:component, "flex flex-col overflow-hidden rounded-box border border-base-300 sm:flex-row")
    add_stimulus_controller(:component, "master-detail")

    add_css(:master, "flex flex-col gap-1 border-b border-base-300 p-2 sm:w-56 sm:border-b-0 sm:border-r")
    add_css(:detail, "flex-1 p-6")
  end
end
