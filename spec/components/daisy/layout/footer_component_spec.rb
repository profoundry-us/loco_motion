require "rails_helper"

RSpec.describe Daisy::Layout::FooterComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with no options" do
    before do
      render_inline(described_class.new)
    end

    describe "rendering" do
      it "renders a footer element" do
        expect(page).to have_css "footer"
      end

      it "adds footer class" do
        expect(page).to have_css "footer.footer"
      end
    end
  end

  context "with custom CSS" do
    let(:custom_class) { "bg-neutral text-neutral-content p-10" }

    before do
      render_inline(described_class.new(css: custom_class))
    end

    describe "rendering" do
      it "applies custom classes" do
        expect(page).to have_css "footer.footer.#{custom_class.gsub(/\s+/, ".")}"
      end
    end
  end

  context "with content" do
    let(:content_text) { "Footer content" }

    before do
      render_inline(described_class.new) { content_text }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content content_text
      end

      it "renders content directly in footer" do
        expect(page).to have_css "footer", text: content_text
      end
    end
  end

  context "with navigation content" do
    let(:title) { "Navigation" }
    let(:links) { ["Home", "About", "Contact"] }

    before do
      render_inline(described_class.new) do
        content_tag(:nav) do
          safe_join([
            content_tag(:h6, title, class: "footer-title"),
            *links.map { |link| content_tag(:a, link, href: "#", class: "link-hover") }
          ])
        end
      end
    end

    describe "rendering" do
      it "renders the nav element" do
        expect(page).to have_css "footer nav"
      end

      it "renders the title" do
        expect(page).to have_css "h6.footer-title", text: title
      end

      it "renders all links" do
        links.each do |link|
          expect(page).to have_link link
        end
      end

      it "applies hover styles to links" do
        expect(page).to have_css "a.link-hover", count: links.length
      end
    end
  end

  context "with multiple navigation sections" do
    let(:sections) do
      [
        { title: "Section 1", links: ["Link 1", "Link 2"] },
        { title: "Section 2", links: ["Link 3", "Link 4"] }
      ]
    end

    before do
      render_inline(described_class.new) do
        safe_join(sections.map do |section|
          content_tag(:nav) do
            safe_join([
              content_tag(:h6, section[:title], class: "footer-title"),
              *section[:links].map { |link| content_tag(:a, link, href: "#", class: "link-hover") }
            ])
          end
        end)
      end
    end

    describe "rendering" do
      it "renders multiple nav sections" do
        expect(page).to have_css "footer nav", count: sections.length
      end

      it "renders all section titles" do
        sections.each do |section|
          expect(page).to have_css "h6.footer-title", text: section[:title]
        end
      end

      it "renders all section links" do
        sections.flat_map { |s| s[:links] }.each do |link|
          expect(page).to have_link link
        end
      end

      it "maintains section order" do
        footer_html = page.find("footer").native.inner_html
        section1_pos = footer_html.index(sections[0][:title])
        section2_pos = footer_html.index(sections[1][:title])

        expect(section1_pos).to be < section2_pos
      end
    end
  end

  context "with complex content" do
    let(:title) { "Complex Footer" }
    let(:custom_class) { "bg-neutral text-neutral-content p-10" }
    let(:copyright) { "Copyright 2024" }

    before do
      render_inline(described_class.new(css: custom_class)) do |footer|
        content_tag(:div, class: "text-center") do
          safe_join([
            content_tag(:h2, title, class: "text-xl font-bold mb-4"),
            content_tag(:p, copyright, class: "text-sm")
          ])
        end
      end
    end

    describe "rendering" do
      it "applies custom styles" do
        expect(page).to have_css "footer.footer.#{custom_class.gsub(/\s+/, ".")}"
      end

      it "renders complex content structure" do
        expect(page).to have_css "footer > div.text-center"
        expect(page).to have_css "h2.text-xl.font-bold.mb-4", text: title
        expect(page).to have_css "p.text-sm", text: copyright
      end

      it "maintains content hierarchy" do
        expect(page).to have_selector "footer > div > h2 + p"
      end
    end
  end
end
