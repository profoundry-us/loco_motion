require "rails_helper"

RSpec.describe Daisy::Feedback::ToastComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "basic toast" do
    let(:toast) { described_class.new }

    before do
      render_inline(toast)
    end

    describe "rendering" do
      it "has the toast class" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with content" do
    let(:content) { "Message" }
    let(:toast) { described_class.new }

    before do
      render_inline(toast) { content }
    end

    describe "rendering" do
      it "renders the content" do
        expect(page).to have_content(content)
      end

      it "has the toast class" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with alert content" do
    let(:alert_content) { "Alert Message" }
    let(:toast) { described_class.new }
    let(:alert_html) do
      content_tag(:div, alert_content, class: "alert alert-info")
    end

    before do
      render_inline(toast) { alert_html }
    end

    describe "rendering" do
      it "renders the alert" do
        expect(page).to have_selector(".toast .alert.alert-info")
      end

      it "renders the alert content" do
        expect(page).to have_content(alert_content)
      end

      it "has the toast class" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with multiple alerts" do
    let(:toast) { described_class.new }
    let(:success_content) { "Success Message" }
    let(:error_content) { "Error Message" }
    let(:alerts_html) do
      content_tag(:div, class: "flex flex-col gap-2") do
        content_tag(:div, success_content, class: "alert alert-success") +
        content_tag(:div, error_content, class: "alert alert-error")
      end
    end

    before do
      render_inline(toast) { alerts_html }
    end

    describe "rendering" do
      it "renders both alerts" do
        expect(page).to have_selector(".toast .alert.alert-success")
        expect(page).to have_selector(".toast .alert.alert-error")
      end

      it "renders both alert contents" do
        expect(page).to have_content(success_content)
        expect(page).to have_content(error_content)
      end

      it "has the toast class" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with custom positioning" do
    let(:position) { "toast-start" }
    let(:toast) { described_class.new(css: position) }

    before do
      render_inline(toast) { "Message" }
    end

    describe "rendering" do
      it "includes position class" do
        expect(page).to have_selector(".toast.toast-start")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with multiple positioning classes" do
    let(:positions) { "toast-start toast-top" }
    let(:toast) { described_class.new(css: positions) }

    before do
      render_inline(toast) { "Message" }
    end

    describe "rendering" do
      it "includes all position classes" do
        positions.split(" ").each do |position|
          expect(page).to have_selector(".toast.#{position}")
        end
      end

      it "maintains default classes" do
        expect(page).to have_selector(".toast")
      end
    end
  end

  context "with complex content structure" do
    let(:toast) { described_class.new }
    let(:complex_content) do
      content_tag(:div, class: "flex flex-col gap-4") do
        content_tag(:div, class: "alert alert-info") do
          content_tag(:div, class: "flex items-center gap-2") do
            content_tag(:span, "Info", class: "font-bold") +
            content_tag(:span, "Description", class: "text-sm")
          end
        end
      end
    end

    before do
      render_inline(toast) { complex_content }
    end

    describe "rendering" do
      it "renders the complex content structure" do
        expect(page).to have_selector(".toast .alert.alert-info")
        expect(page).to have_selector(".toast .flex.items-center.gap-2")
        expect(page).to have_selector(".toast .font-bold")
        expect(page).to have_selector(".toast .text-sm")
      end

      it "preserves text content" do
        expect(page).to have_content("Info")
        expect(page).to have_content("Description")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".toast")
      end
    end
  end
end
