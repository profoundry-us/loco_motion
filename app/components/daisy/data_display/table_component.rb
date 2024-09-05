#
# The Table component is used to render HTML tables with rows, columns, and headers.
#
# @!parse class Daisy::DataDisplay::TableComponent < LocoMotion::BaseComponent; end
class Daisy::DataDisplay::TableComponent < LocoMotion.configuration.base_component_class

  class HeadColumnComponent < BasicComponent
    def before_render
      set_tag_name :component, :th
    end
  end

  class HeadComponent < BasicComponent
    renders_many :columns, HeadColumnComponent

    def before_render
      set_tag_name :component, :thead
    end

    def call
      part(:component) do
        content_tag(:tr) do
          columns.each do |column|
            concat(column)
          end
        end
      end
    end
  end

  class BodyColumnComponent < BasicComponent
    def before_render
      set_tag_name :component, :td
    end
  end

  class BodyRowComponent < BasicComponent
    renders_many :columns, BodyColumnComponent

    def before_render
      set_tag_name :component, :tr
    end

    def call
      part(:component) do
        columns.each do |column|
          concat(column)
        end
      end
    end
  end

  class BodyComponent < BasicComponent
    renders_many :rows, BodyRowComponent

    def before_render
      set_tag_name :component, :tbody
    end

    def call
      part(:component) do
        content_tag(:tr) do
          rows.each do |row|
            concat(row)
          end
        end
      end
    end
  end

  class SectionComponent < BasicComponent
    renders_one :head, HeadComponent
    renders_one :body, BodyComponent
    renders_many :rows, BodyRowComponent

    def before_render
      set_tag_name :component, :section
    end

    def call
      # Sections can't be rendered inside a <table> tag, so we don't render the
      # typical `part(:component)` here.
      concat(head) if head?

      if body?
        concat(body)
      else
        content_tag(:tbody) do
          rows.each do |row|
            concat(row)
          end
        end
      end
    end
  end

  renders_one :head, HeadComponent
  renders_one :body, BodyComponent
  renders_many :rows, BodyRowComponent
  renders_many :sections, SectionComponent

  set_component_name :table

  #
  # Instantiate a new Table component. This component takes no content, but
  # requires you to utilize the optional <code>head</code> slot, and one of the
  # <code>body</code> or <code>rows</code> slots.
  #
  # @example
  #  = daisy_table do |table|
  #    - table.head do |head|
  #      - head.with_column do
  #        Column 1
  #      - head.with_column do
  #        Column 2
  #
  #    - table.with_row do |row|
  #      - row.with_column do
  #        Row 1 - Column 1
  #      - row.with_column do
  #        Row 1 - Column 2
  #    - table.with_row do |row|
  #      - row.with_column do
  #        Row 2 - Column 1
  #      - row.with_column do
  #        Row 2 - Column 2
  #
  # For more complex tables, you can use the <code>section</code> slot which
  # takes a <code>head</code> and <code>body</code> slot allowing you to build a
  # table with multiple headers and bodies.
  #
  # Please see the demo for more examples of usage.
  #
  def initialize(*args, **kws, &block)
    super
  end

  def before_render
    setup_component
  end

  private

  def setup_component
    set_tag_name(:component, :table)
    add_css(:component, "table")
  end
end
