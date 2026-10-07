# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataDisplay::TableComponent, type: :component do
  context "basic table" do
    let(:table) { described_class.new }

    before do
      render_inline(table) do |t|
        t.with_head do |head|
          head.with_column { "Column 1" }
          head.with_column { "Column 2" }
        end

        t.with_row do |row|
          row.with_column { "foo" }
          row.with_column { "bar" }
        end

        t.with_row do |row|
          row.with_column { "fizz" }
          row.with_column { "buzz" }
        end
      end
    end

    describe "rendering" do
      it "has the table class" do
        expect(page).to have_selector(".table")
      end

      it "renders the header columns" do
        expect(page).to have_selector("thead tr th", text: "Column 1")
        expect(page).to have_selector("thead tr th", text: "Column 2")
      end

      it "renders the rows" do
        expect(page).to have_selector("tbody tr", count: 2)
        expect(page).to have_selector("tbody tr:first-child td", text: "foo")
        expect(page).to have_selector("tbody tr:first-child td", text: "bar")
        expect(page).to have_selector("tbody tr:last-child td", text: "fizz")
        expect(page).to have_selector("tbody tr:last-child td", text: "buzz")
      end
    end
  end

  context "with a sticky head" do
    before do
      render_inline(described_class.new) do |t|
        t.with_head(sticky: "top", row_css: "top-0 bg-base-100") do |head|
          head.with_column { "Name" }
        end
        t.with_row do |row|
          row.with_column { "Alice" }
        end
      end
    end

    it "pins the header row, not the thead" do
      expect(page).to have_selector("thead > tr.sticky.top-0.bg-base-100[data-controller='loco-sticky']")
      expect(page).not_to have_selector("thead.sticky")
      expect(page).not_to have_selector("thead[data-controller]")
    end

    it "omits the edge value for the top edge" do
      expect(page).not_to have_selector("[data-loco-sticky-edge-value]")
    end

    it "leaves the cells alone" do
      expect(page).not_to have_selector("th.sticky")
      expect(page).not_to have_selector("th[data-controller]")
    end
  end

  context "without a sticky head" do
    before do
      render_inline(described_class.new) do |t|
        t.with_head(row_css: "font-bold") do |head|
          head.with_column { "Name" }
        end
        t.with_row do |row|
          row.with_column { "Alice" }
        end
      end
    end

    it "still renders the header row as a plain styled tr" do
      expect(page).to have_selector("thead > tr.font-bold")
      expect(page).not_to have_selector("tr.sticky")
      expect(page).not_to have_selector("[data-controller='loco-sticky']")
    end
  end

  context "with pinned column cells" do
    before do
      render_inline(described_class.new) do |t|
        t.with_head do |head|
          head.with_column(sticky: "left", css: "left-0") { "Name" }
          head.with_column { "Q1" }
        end
        t.with_row do |row|
          row.with_column(sticky: "left", css: "left-0") { "Alice" }
          row.with_column { "42" }
        end
      end
    end

    it "pins the header cell" do
      expect(page).to have_selector("th.sticky.left-0[data-controller='loco-sticky'][data-loco-sticky-edge-value='left']", text: "Name")
      expect(page).not_to have_selector("th.sticky", text: "Q1")
    end

    it "pins the body cell" do
      expect(page).to have_selector("td.sticky.left-0[data-controller='loco-sticky'][data-loco-sticky-edge-value='left']", text: "Alice")
      expect(page).not_to have_selector("td.sticky", text: "42")
    end

    it "does not pin the header row" do
      expect(page).not_to have_selector("tr.sticky")
    end
  end

  context "with sections" do
    let(:table) { described_class.new(css: "table-pin-rows") }

    before do
      render_inline(table) do |t|
        t.with_section do |section|
          section.with_head do |head|
            head.with_column(css: "bg-blue-100") { "1900s" }
          end

          section.with_body do |body|
            body.with_row do |row|
              row.with_column { "1901" }
            end
            body.with_row do |row|
              row.with_column { "1902" }
            end
          end
        end

        t.with_section do |section|
          section.with_head do |head|
            head.with_column(css: "bg-blue-100") { "1910s" }
          end

          section.with_body do |body|
            body.with_row do |row|
              row.with_column { "1911" }
            end
            body.with_row do |row|
              row.with_column { "1912" }
            end
          end
        end
      end
    end

    describe "rendering" do
      it "has the table and pin-rows classes" do
        expect(page).to have_selector(".table.table-pin-rows")
      end

      it "renders multiple headers" do
        expect(page).to have_selector("thead", count: 2)
      end

      it "renders headers with custom classes" do
        expect(page).to have_selector("thead:first-of-type tr th.bg-blue-100", text: "1900s")
        expect(page).to have_selector("thead:last-of-type tr th.bg-blue-100", text: "1910s")
      end

      it "renders bodies" do
        # First section
        expect(page).to have_selector("tbody:first-of-type tr", count: 2)
        expect(page).to have_selector("tbody:first-of-type tr:first-child td", text: "1901")
        expect(page).to have_selector("tbody:first-of-type tr:last-child td", text: "1902")

        # Second section
        expect(page).to have_selector("tbody:last-of-type tr", count: 2)
        expect(page).to have_selector("tbody:last-of-type tr:first-child td", text: "1911")
        expect(page).to have_selector("tbody:last-of-type tr:last-child td", text: "1912")
      end
    end
  end
end
