require "rails_helper"

RSpec.describe Daisy::DataDisplay::AccordionComponent, type: :component do
  context "basic accordion" do
    let(:accordion) { described_class.new }

    before do
      render_inline(accordion)
    end

    describe "rendering" do
      it "generates a unique name" do
        expect(accordion.name).to match(/accordion-[a-f0-9-]+/)
      end
    end
  end

  context "with custom name" do
    let(:name) { "custom-accordion" }
    let(:accordion) { described_class.new(name: name) }

    before do
      render_inline(accordion)
    end

    describe "rendering" do
      it "uses the provided name" do
        expect(accordion.name).to eq(name)
      end
    end
  end

  context "with sections" do
    let(:accordion) { described_class.new }
    let(:section_titles) { ["Section 1", "Section 2", "Section 3"] }

    before do
      render_inline(accordion) do |acc|
        section_titles.each do |title|
          acc.with_section(title: title) { "Content for #{title}" }
        end
      end
    end

    describe "rendering" do
      it "renders all sections" do
        expect(page).to have_selector(".collapse", count: 3)
      end

      it "renders section titles" do
        section_titles.each do |title|
          expect(page).to have_content(title)
        end
      end

      it "renders section content" do
        section_titles.each do |title|
          expect(page).to have_content("Content for #{title}")
        end
      end

      it "includes radio buttons" do
        expect(page).to have_selector("input[type='radio']", count: 3)
      end

      it "uses accordion name for all radio buttons" do
        name = accordion.name
        expect(page).to have_selector("input[type='radio'][name='#{name}']", count: 3)
      end
    end
  end

  context "with arrow modifier" do
    let(:accordion) { described_class.new(modifier: :arrow) }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section") { "Content" }
      end
    end

    describe "rendering" do
      it "includes collapse-arrow class" do
        expect(page).to have_selector(".collapse.collapse-arrow")
      end
    end
  end

  context "with plus modifier" do
    let(:accordion) { described_class.new(modifier: :plus) }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section") { "Content" }
      end
    end

    describe "rendering" do
      it "includes collapse-plus class" do
        expect(page).to have_selector(".collapse.collapse-plus")
      end
    end
  end

  context "with checked section" do
    let(:accordion) { described_class.new }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section", checked: true) { "Content" }
      end
    end

    describe "rendering" do
      it "includes checked attribute on radio button" do
        expect(page).to have_selector("input[type='radio'][checked]")
      end
    end
  end

  context "with section value" do
    let(:accordion) { described_class.new }
    let(:value) { "section-value" }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section", value: value) { "Content" }
      end
    end

    describe "rendering" do
      it "includes value attribute on radio button" do
        expect(page).to have_selector("input[type='radio'][value='#{value}']")
      end
    end
  end

  context "with custom section name" do
    let(:accordion) { described_class.new }
    let(:section_name) { "custom-section" }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section", name: section_name) { "Content" }
      end
    end

    describe "rendering" do
      it "uses custom name for radio button" do
        expect(page).to have_selector("input[type='radio'][name='#{section_name}']")
      end
    end
  end

  context "with custom section title" do
    let(:accordion) { described_class.new }

    before do
      render_inline(accordion) do |acc|
        acc.with_section do |section|
          section.with_title { "<span class='text-red-500'>Custom Title</span>".html_safe }
          "Content"
        end
      end
    end

    describe "rendering" do
      it "renders custom title HTML" do
        expect(page).to have_selector("span.text-red-500", text: "Custom Title")
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "Accordion tooltip" }
    let(:accordion) { described_class.new(tip: tip) }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section") { "Content" }
      end
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".tooltip")
      end

      it "sets data-tip attribute" do
        expect(page).to have_selector("[data-tip='#{tip}']")
      end
    end
  end

  context "with multiple sections and different names" do
    let(:accordion) { described_class.new }

    before do
      render_inline(accordion) do |acc|
        acc.with_section(title: "Section 1", name: "group1") { "Content 1" }
        acc.with_section(title: "Section 2", name: "group1") { "Content 2" }
        acc.with_section(title: "Section A", name: "group2") { "Content A" }
        acc.with_section(title: "Section B", name: "group2") { "Content B" }
      end
    end

    describe "rendering" do
      it "groups radio buttons by name" do
        expect(page).to have_selector("input[type='radio'][name='group1']", count: 2)
        expect(page).to have_selector("input[type='radio'][name='group2']", count: 2)
      end

      it "renders all sections" do
        expect(page).to have_selector(".collapse", count: 4)
        expect(page).to have_content("Section 1")
        expect(page).to have_content("Section 2")
        expect(page).to have_content("Section A")
        expect(page).to have_content("Section B")
      end
    end
  end
end
