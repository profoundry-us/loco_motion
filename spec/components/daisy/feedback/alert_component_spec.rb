require "rails_helper"

RSpec.describe Daisy::Feedback::AlertComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with basic content" do
    let(:content) { "Alert message" }
    let(:alert) { described_class.new }

    before do
      render_inline(alert) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content content
      end

      it "has the alert role" do
        expect(page).to have_selector("[role='alert']")
      end

      it "has the alert class" do
        expect(page).to have_selector(".alert")
      end

      it "renders content directly without wrapper when no icon" do
        expect(page).to have_selector(".alert", text: content)
        expect(page).not_to have_selector(".alert > div", text: content)
      end
    end
  end

  context "with icon" do
    let(:content) { "Alert with icon" }
    let(:icon) { "information-circle" }
    let(:alert) { described_class.new(icon: icon) }

    before do
      render_inline(alert) { content }
    end

    describe "rendering" do
      it "renders the icon" do
        expect(page).to have_selector(".alert svg[data-slot='icon']")
      end

      it "wraps content when icon is present" do
        expect(page).to have_selector(".alert > div", text: content)
      end
    end
  end

  context "with custom CSS classes" do
    let(:custom_class) { "alert-info" }
    let(:alert) { described_class.new(css: custom_class) }

    before do
      render_inline(alert) { "Info alert" }
    end

    describe "rendering" do
      it "includes the custom class" do
        expect(page).to have_selector(".alert.#{custom_class}")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".alert")
      end
    end
  end

  context "with different alert types" do
    {
      info: "alert-info",
      success: "alert-success",
      warning: "alert-warning",
      error: "alert-error"
    }.each do |type, class_name|
      context "with #{type} type" do
        let(:alert) { described_class.new(css: class_name) }
        let(:content) { "#{type.to_s.titleize} message" }

        before do
          render_inline(alert) { content }
        end

        describe "rendering" do
          it "renders with correct class" do
            expect(page).to have_selector(".alert.#{class_name}")
          end

          it "displays the content" do
            expect(page).to have_content(content)
          end
        end
      end
    end
  end

  context "with custom HTML content" do
    let(:alert) { described_class.new }
    let(:custom_content) do
      content_tag(:div, class: "custom-wrapper") do
        content_tag(:span, "Custom", class: "label") +
        content_tag(:strong, "Content")
      end
    end

    before do
      render_inline(alert) { custom_content }
    end

    describe "rendering" do
      it "renders custom HTML structure" do
        expect(page).to have_selector(".alert .custom-wrapper")
        expect(page).to have_selector(".alert .custom-wrapper .label")
        expect(page).to have_selector(".alert .custom-wrapper strong")
      end

      it "preserves text content" do
        expect(page).to have_content("Custom")
        expect(page).to have_content("Content")
      end
    end
  end

  context "with icon HTML options" do
    let(:alert) { described_class.new(icon: "check-circle", icon_html: { variant: :outline }) }

    before do
      render_inline(alert) { "Success message" }
    end

    describe "rendering" do
      it "renders the icon with outline variant" do
        expect(page).to have_selector(".alert svg[data-slot='icon']")
      end
    end
  end
end
