class DocNoteComponent < ApplicationComponent

  define_modifiers :note, :tip, :todo, :warning

  define_parts :icon, :content_wrapper

  def initialize(*args, **kws, &block)
    super

    @icon = config_option(:icon)
    @title = config_option(:title)
  end

  def before_render
    add_css(:component, "alert border")

    add_css(:icon, "where:size-6")

    setup_note if @config.modifiers.include?(:note) || @config.modifiers.blank?
    setup_tip if @config.modifiers.include?(:tip)
    setup_todo if @config.modifiers.include?(:todo)
    setup_warning if @config.modifiers.include?(:warning)
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

    add_css(:component, "border-purple-600 bg-purple-100")
    add_css(:icon, "text-purple-600")
  end

  def setup_warning
    @default_icon = "exclamation-triangle"
    @default_title = "Warning"

    add_css(:component, "border-warning bg-warning/10")
    add_css(:icon, "text-warning")
  end

end
