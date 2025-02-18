#
# The Table component creates structured data tables with support for headers,
# multiple sections, and complex layouts. It provides a clean, semantic way to
# display tabular data while maintaining proper HTML structure.
#
# @slot head A header section containing column titles.
# @slot body A body section containing rows of data.
# @slot row+ Individual rows that can be added directly to the table.
# @slot section+ Multiple sections, each with its own header and body, for
#   complex table layouts.
#
# @loco_example Basic Usage
#   = daisy_table do |table|
#     - table.with_head do |head|
#       - head.with_column { "Name" }
#       - head.with_column { "Role" }
#       - head.with_column { "Department" }
#
#     - table.with_row do |row|
#       - row.with_column { "John Smith" }
#       - row.with_column { "Developer" }
#       - row.with_column { "Engineering" }
#
#     - table.with_row do |row|
#       - row.with_column { "Jane Doe" }
#       - row.with_column { "Designer" }
#       - row.with_column { "Product" }
#
# @loco_example With Body Container
#   = daisy_table do |table|
#     - table.with_head do |head|
#       - head.with_column { "Product" }
#       - head.with_column { "Price" }
#
#     - table.with_body do |body|
#       - body.with_row do |row|
#         - row.with_column { "Basic Plan" }
#         - row.with_column { "$10/mo" }
#       - body.with_row do |row|
#         - row.with_column { "Pro Plan" }
#         - row.with_column { "$20/mo" }
#
# @loco_example With Multiple Sections
#   = daisy_table do |table|
#     - table.with_section do |section|
#       - section.with_head do |head|
#         - head.with_column { "Active Users" }
#         - head.with_column { "Status" }
#
#       - section.with_body do |body|
#         - body.with_row do |row|
#           - row.with_column { "Alice" }
#           - row.with_column { "Online" }
#
#     - table.with_section do |section|
#       - section.with_head do |head|
#         - head.with_column { "Inactive Users" }
#         - head.with_column { "Last Seen" }
#
#       - section.with_body do |body|
#         - body.with_row do |row|
#           - row.with_column { "Bob" }
#           - row.with_column { "2 days ago" }
#
class Daisy::DataDisplay::TableComponent < LocoMotion::BaseComponent

  #
  # A component for rendering individual header cells (`<th>`) within a table
  # header row.
  #
  class HeadColumnComponent < LocoMotion::BasicComponent
    def before_render
      set_tag_name :component, :th
    end
  end

  #
  # A component for rendering the table header (`<thead>`) section. Contains
  # header columns that define the structure of the table.
  #
  # @slot column+ Individual header cells within the header row.
  #
  class HeadComponent < LocoMotion::BasicComponent
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

  #
  # A component for rendering individual data cells (`<td>`) within a table row.
  #
  class BodyColumnComponent < LocoMotion::BasicComponent
    def before_render
      set_tag_name :component, :td
    end
  end

  #
  # A component for rendering table rows (`<tr>`) containing data cells.
  #
  # @slot column+ Individual data cells within the row.
  #
  class BodyRowComponent < LocoMotion::BasicComponent
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

  #
  # A component for rendering the table body (`<tbody>`) section. Contains rows
  # of data.
  #
  # @slot row+ Individual rows of data within the body.
  #
  class BodyComponent < LocoMotion::BasicComponent
    renders_many :rows, BodyRowComponent

    def before_render
      set_tag_name :component, :tbody
    end

    def call
      part(:component) do
        rows.each do |row|
          concat(row)
        end
      end
    end
  end

  #
  # A component for grouping related table content into sections. Each section
  # can have its own header and body, allowing for complex table layouts.
  #
  # @slot head A header section for this group of data.
  # @slot body A body section for this group of data.
  # @slot row+ Individual rows that can be added directly to this section.
  #
  class SectionComponent < LocoMotion::BasicComponent
    renders_one :head, HeadComponent
    renders_one :body, BodyComponent
    renders_many :rows, BodyRowComponent

    def before_render
      set_tag_name :component, :section
    end

    def call
      # Sections can't be rendered inside a `<table>` tag, so we don't render the
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
  # requires you to utilize the optional `head` slot, and one of the `body` or
  # `rows` slots.
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
