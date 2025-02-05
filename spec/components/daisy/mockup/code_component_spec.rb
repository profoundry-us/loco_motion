require "rails_helper"

RSpec.describe Daisy::Mockup::CodeComponent, type: :component do
  context "basic code mockup" do
    let(:code) { described_class.new }

    before do
      render_inline(code) do |c|
        c.with_line { "const message = 'Hello World';" }
        c.with_line { "console.log(message);" }
      end
    end

    describe "rendering" do
      it "has the mockup-code class" do
        expect(page).to have_selector(".mockup-code")
      end

      it "renders the code lines" do
        expect(page).to have_text("const message = 'Hello World';")
        expect(page).to have_text("console.log(message);")
      end
    end
  end

  context "with prefix" do
    let(:code) { described_class.new }

    before do
      render_inline(code) do |c|
        c.with_line(prefix: ">") { "npm install package" }
        c.with_line { "installing..." }
      end
    end

    describe "rendering" do
      it "renders lines with custom prefix" do
        expect(page).to have_selector("pre[data-prefix='>']")
      end

      it "renders the code content" do
        expect(page).to have_text("npm install package")
        expect(page).to have_text("installing...")
      end
    end
  end

  context "without lines" do
    let(:code) { described_class.new(prefix: "") }

    before do
      render_inline(code) do
        "No lines content"
      end
    end

    describe "rendering" do
      it "renders content in a single line" do
        expect(page).to have_selector(".mockup-code pre code", text: "No lines content")
      end

      it "adds the correct CSS classes when prefix is blank" do
        expect(page).to have_selector("pre[class*='before:!hidden']")
        expect(page).to have_selector("pre[class*='ml-6']")
      end
    end
  end
end
