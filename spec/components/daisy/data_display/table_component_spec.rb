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
        expect(page).to have_selector("tbody:first-of-type tr", count: 3) # Including the empty tr
        expect(page).to have_selector("tbody:first-of-type tr:nth-child(2) td", text: "1901")
        expect(page).to have_selector("tbody:first-of-type tr:last-child td", text: "1902")

        # Second section
        expect(page).to have_selector("tbody:last-of-type tr", count: 3) # Including the empty tr
        expect(page).to have_selector("tbody:last-of-type tr:nth-child(2) td", text: "1911")
        expect(page).to have_selector("tbody:last-of-type tr:last-child td", text: "1912")
      end
    end
  end
end
