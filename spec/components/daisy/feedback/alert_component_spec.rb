# frozen_string_literal: true

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

      it "renders the content directly in the alert element when there is no icon" do
        expect(page).to have_selector(".alert", text: content)
        expect(page).not_to have_selector(".alert > div:not([data-slot='icon'])", text: content)
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
        expect(page).to have_selector(".alert svg")
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
        expect(page).to have_selector(".alert svg")
      end
    end
  end

  context "with timeout parameter" do
    let(:alert) { described_class.new(timeout: 3000) }

    before do
      render_inline(alert) { "Auto-dismiss alert" }
    end

    describe "rendering" do
      it "does not include the stimulus controller when autoclose is false" do
        expect(page).not_to have_selector("[data-controller='loco-alert']")
      end

      it "does not include timeout value attribute when autoclose is false" do
        expect(page).not_to have_selector("[data-loco-alert-timeout-value]")
      end

      it "does not show close button by default" do
        expect(page).not_to have_selector(".alert button")
      end
    end
  end

  context "with timeout and autoclose parameters" do
    let(:alert) { described_class.new(timeout: 3000, autoclose: true) }

    before do
      render_inline(alert) { "Auto-dismiss alert" }
    end

    describe "rendering" do
      it "includes the stimulus controller" do
        expect(page).to have_selector("[data-controller='loco-alert']")
      end

      it "includes the timeout value attribute when autoclose is true" do
        expect(page).to have_selector("[data-loco-alert-timeout-value='3000']")
      end

      it "does not show close button by default" do
        expect(page).not_to have_selector(".alert button")
      end
    end
  end

  context "with timeout set to false" do
    let(:alert) { described_class.new(timeout: false) }

    before do
      render_inline(alert) { "No auto-dismiss alert" }
    end

    describe "rendering" do
      it "does not include the stimulus controller" do
        expect(page).not_to have_selector("[data-controller='loco-alert']")
      end

      it "does not include timeout value attribute" do
        expect(page).not_to have_selector("[data-loco-alert-timeout-value]")
      end

      it "does not show close button by default" do
        expect(page).not_to have_selector(".alert button")
      end
    end
  end

  context "without timeout parameter" do
    let(:alert) { described_class.new }

    before do
      render_inline(alert) { "Default alert" }
    end

    describe "rendering" do
      it "does not include the stimulus controller" do
        expect(page).not_to have_selector("[data-controller='loco-alert']")
      end

      it "does not include timeout value attribute when autoclose is false" do
        expect(page).not_to have_selector("[data-loco-alert-timeout-value]")
      end

      it "does not show close button by default" do
        expect(page).not_to have_selector(".alert button")
      end
    end
  end

  context "with href parameter" do
    let(:alert) { described_class.new(href: "/docs") }

    before do
      render_inline(alert) { "Clickable alert" }
    end

    describe "rendering" do
      it "renders as an anchor tag" do
        expect(page).to have_selector("a.alert")
      end

      it "includes the href attribute" do
        expect(page).to have_selector("a[href='/docs']")
      end
    end
  end

  context "with action parameter" do
    let(:alert) { described_class.new(action: "click->my-controller#handle") }

    before do
      render_inline(alert) { "Action alert" }
    end

    describe "rendering" do
      it "includes the data-action attribute" do
        expect(page).to have_selector("[data-action='click->my-controller#handle']")
      end
    end
  end

  context "with closable parameter" do
    context "when closable is true" do
      let(:alert) { described_class.new(closable: true) }

      before do
        render_inline(alert) { "Closable alert" }
      end

      describe "rendering" do
        it "includes the stimulus controller" do
          expect(page).to have_selector("[data-controller='loco-alert']")
        end

        it "shows close button" do
          expect(page).to have_selector(".alert button")
        end

        it "close button has correct action" do
          expect(page).to have_selector("button[data-action='click->loco-alert#close']")
        end

        it "places the close button in the trailing grid column, not absolutely" do
          expect(page).to have_selector('.alert button.where\\:justify-self-end')
          expect(page).not_to have_selector('.alert button.where\\:absolute')
        end

        it "does not reserve right padding on the alert" do
          expect(page).not_to have_selector('.alert.where\\:pr-10')
        end
      end
    end

    context "when closable is false" do
      let(:alert) { described_class.new(closable: false) }

      before do
        render_inline(alert) { "Non-closable alert" }
      end

      describe "rendering" do
        it "does not include the stimulus controller" do
          expect(page).not_to have_selector("[data-controller='loco-alert']")
        end

        it "does not show close button" do
          expect(page).not_to have_selector(".alert button")
        end

        it "does not render close-button placement styling" do
          expect(page).not_to have_selector('.alert.where\\:pr-10')
          expect(page).not_to have_selector('.alert button.where\\:justify-self-end')
        end
      end
    end
  end
end
