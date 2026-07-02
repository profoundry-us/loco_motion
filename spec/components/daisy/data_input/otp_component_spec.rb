# frozen_string_literal: true

require "rails_helper"

RSpec.describe Daisy::DataInput::OtpComponent, type: :component do
  context "basic otp" do
    let(:otp) { described_class.new(name: "verification_code") }

    before do
      render_inline(otp)
    end

    describe "rendering" do
      it "renders as a label with the otp class" do
        expect(page).to have_selector("label.otp")
      end

      it "renders four digit boxes by default" do
        expect(page).to have_selector("label.otp > span", count: 4, visible: :all)
      end

      it "renders the digit boxes before the input" do
        children = page.find("label.otp").all("> *", visible: :all)
        expect(children[0..3].map(&:tag_name)).to all(eq("span"))
        expect(children.last.tag_name).to eq("input")
      end

      it "renders a single input with the numeric one-time-code attributes" do
        expect(page).to have_selector(
          "label.otp input[type='text'][inputmode='numeric'][autocomplete='one-time-code']",
          count: 1,
          visible: :all
        )
      end

      it "sets maxlength and pattern from the default length" do
        input = page.find("label.otp > input", visible: :all)
        expect(input[:maxlength]).to eq("4")
        expect(input[:pattern]).to eq("\\d{4}")
      end

      it "sets the name attribute on the input" do
        expect(page).to have_selector("input[name='verification_code']", visible: :all)
      end
    end
  end

  context "with a custom length" do
    let(:otp) { described_class.new(name: "code", length: 6) }

    before do
      render_inline(otp)
    end

    it "renders six digit boxes" do
      expect(page).to have_selector("label.otp > span", count: 6, visible: :all)
    end

    it "sets maxlength and pattern from the length" do
      input = page.find("label.otp > input", visible: :all)
      expect(input[:maxlength]).to eq("6")
      expect(input[:pattern]).to eq("\\d{6}")
    end
  end

  context "with an invalid length" do
    it "raises for a length above 8" do
      expect { described_class.new(length: 9) }.to raise_error(ArgumentError, /between 1 and 8/)
    end

    it "raises for a length below 1" do
      expect { described_class.new(length: 0) }.to raise_error(ArgumentError, /between 1 and 8/)
    end
  end

  context "with id, value, and required" do
    let(:otp) { described_class.new(name: "otp_code", id: "otp-field", value: "1234", required: true) }

    before do
      render_inline(otp)
    end

    it "sets the id attribute on the input" do
      expect(page).to have_selector("input#otp-field", visible: :all)
    end

    it "pre-fills the value" do
      expect(page).to have_selector("input[value='1234']", visible: :all)
    end

    it "marks the input as required" do
      expect(page).to have_selector("input[required]", visible: :all)
    end
  end

  context "with custom CSS" do
    let(:otp) { described_class.new(name: "pin", css: "otp-joined otp-primary otp-lg") }

    before do
      render_inline(otp)
    end

    it "applies custom CSS classes alongside the otp class" do
      expect(page).to have_selector("label.otp.otp-joined.otp-primary.otp-lg")
    end
  end

  context "with custom HTML attributes" do
    let(:otp) { described_class.new(name: "code", html: { id: "my-otp", data: { test: "value" } }) }

    before do
      render_inline(otp)
    end

    it "passes attributes through to the wrapper" do
      expect(page).to have_selector("label.otp#my-otp[data-test='value']")
    end
  end
end
