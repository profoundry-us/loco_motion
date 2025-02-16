require "rails_helper"

RSpec.describe Daisy::DataDisplay::KbdComponent, type: :component do
  context "basic keyboard key" do
    let(:kbd) { described_class.new }
    let(:key) { "F" }

    before do
      render_inline(kbd) { key }
    end

    describe "rendering" do
      it "has the kbd class" do
        expect(page).to have_selector(".kbd")
      end

      it "renders as a span element" do
        expect(page).to have_selector("span.kbd")
      end

      it "renders the key content" do
        expect(page).to have_content(key)
      end
    end
  end

  context "with different sizes" do
    {
      "lg" => "large",
      "md" => "medium",
      "sm" => "small",
      "xs" => "extra small"
    }.each do |size_class, size_name|
      context "with #{size_name} size" do
        let(:kbd) { described_class.new(css: "kbd-#{size_class}") }

        before do
          render_inline(kbd) { "Shift" }
        end

        describe "rendering" do
          it "includes size class" do
            expect(page).to have_selector(".kbd.kbd-#{size_class}")
          end

          it "maintains default classes" do
            expect(page).to have_selector(".kbd")
          end
        end
      end
    end
  end

  context "with function keys" do
    {
      "⌘" => "Command",
      "⌥" => "Option",
      "⇧" => "Shift",
      "⌃" => "Control"
    }.each do |symbol, key_name|
      context "with #{key_name} key" do
        let(:kbd) { described_class.new }

        before do
          render_inline(kbd) { symbol }
        end

        describe "rendering" do
          it "renders the symbol" do
            expect(page).to have_content(symbol)
          end

          it "has the kbd class" do
            expect(page).to have_selector(".kbd")
          end
        end
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "Press this key" }
    let(:kbd) { described_class.new(tip: tip) }

    before do
      render_inline(kbd) { "F" }
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".kbd.tooltip")
      end

      it "sets data-tip attribute" do
        expect(page).to have_css("[data-tip=\"#{tip}\"]")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".kbd")
      end
    end
  end

  context "with custom CSS" do
    let(:custom_class) { "bg-primary text-primary-content" }
    let(:kbd) { described_class.new(css: custom_class) }

    before do
      render_inline(kbd) { "F" }
    end

    describe "rendering" do
      it "includes custom classes" do
        custom_class.split.each do |css_class|
          expect(page).to have_selector(".kbd.#{css_class}")
        end
      end

      it "maintains default classes" do
        expect(page).to have_selector(".kbd")
      end
    end
  end

  context "with special characters" do
    let(:kbd) { described_class.new }

    ["[", "]", "\\"].each do |char|
      it "renders #{char} correctly" do
        render_inline(kbd) { char }
        expect(page).to have_content(char)
      end
    end
  end

  context "with longer text" do
    let(:kbd) { described_class.new }
    let(:text) { "caps lock" }

    before do
      render_inline(kbd) { text }
    end

    describe "rendering" do
      it "renders the full text" do
        expect(page).to have_content(text)
      end

      it "maintains default classes" do
        expect(page).to have_selector(".kbd")
      end
    end
  end
end
