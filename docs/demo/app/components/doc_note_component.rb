# frozen_string_literal: true

class DocNoteComponent < ApplicationComponent
  define_modifiers :note, :tip, :todo, :warning, :error

  define_parts :icon, :content_wrapper

  def initialize(*args, **kws, &block)
    super

    @icon = config_option(:icon)
    @title = config_option(:title)
  end

  def before_render
    add_css(:component, "alert border grid-cols-[minmax(0,1fr)]")

    # The alert is a CSS grid with justify-items: start, so its content cell
    # sizes to fit-content and an unbreakable doc_code line blows the note out
    # of the viewport on narrow screens. A definite minmax(0,1fr) column plus
    # a stretched, shrinkable cell keeps the note at container width and lets
    # the code scroll instead.
    add_css(:content_wrapper, "min-w-0 justify-self-stretch")

    add_css(:icon, "where:size-6")

    setup_note if @config.modifiers.include?(:note) || @config.modifiers.blank?
    setup_tip if @config.modifiers.include?(:tip)
    setup_todo if @config.modifiers.include?(:todo)
    setup_warning if @config.modifiers.include?(:warning)
    setup_error if @config.modifiers.include?(:error)
  end

  def setup_note
    @default_icon = "information-circle"
    @default_title = "Note"

    add_css(:component, "border-info bg-info/10")
    add_css(:icon, "text-info")
  end

  def setup_tip
    @default_icon = "chat-bubble-oval-left-ellipsis"
    @default_title = "Tip"

    add_css(:component, "border-success bg-success/10")
    add_css(:icon, "text-success")
  end

  def setup_todo
    @default_icon = "ellipsis-horizontal-circle"
    @default_title = "Todo"

    add_css(:component, "border-accent bg-accent/10")
    add_css(:icon, "text-accent")
  end

  def setup_warning
    @default_icon = "exclamation-triangle"
    @default_title = "Warning"

    add_css(:component, "border-warning bg-warning/10")
    add_css(:icon, "text-warning")
  end

  def setup_error
    @default_icon = "exclamation-triangle"
    @default_title = "Error"

    add_css(:component, "border-error bg-error/10")
    add_css(:icon, "text-error")
  end
end
