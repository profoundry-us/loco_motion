require "rails_helper"

RSpec.describe Daisy::DataDisplay::CountdownComponent, type: :component do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  context "with simple duration" do
    let(:duration) { 60.seconds }

    before do
      render_inline(described_class.new(duration))
    end

    describe "rendering" do
      it "renders the countdown container" do
        expect(page).to have_selector(".countdown")
      end

      it "renders with flex class" do
        expect(page).to have_selector(".flex")
      end

      it "renders seconds value" do
        expect(page).to have_selector("[style*='--value: 60']")
      end

      it "adds stimulus controller" do
        expect(page).to have_selector("[data-controller='loco-countdown']")
      end
    end
  end

  context "with complex duration" do
    let(:duration) { ActiveSupport::Duration.build(3725) } # 1h 2m 5s

    before do
      render_inline(described_class.new(duration))
    end

    describe "rendering" do
      it "renders hours value" do
        expect(page).to have_selector("[style*='--value: 1']")
      end

      it "renders minutes value" do
        expect(page).to have_selector("[style*='--value: 2']")
      end

      it "renders seconds value" do
        expect(page).to have_selector("[style*='--value: 5']")
      end

      it "renders default separators" do
        expect(page).to have_text(":")
      end
    end
  end

  context "with custom separator" do
    let(:duration) { ActiveSupport::Duration.build(3725) }
    let(:separator) { "-" }

    before do
      render_inline(described_class.new(duration: duration, separator: separator))
    end

    describe "rendering" do
      it "renders custom separator" do
        expect(page).to have_text(separator)
      end
    end
  end

  context "with words modifier" do
    let(:duration) { ActiveSupport::Duration.build(3725) }

    before do
      render_inline(described_class.new(duration: duration, modifier: :words))
    end

    describe "rendering" do
      it "renders word separators" do
        expect(page).to have_text("hours")
        expect(page).to have_text("minutes")
        expect(page).to have_text("seconds")
      end

      it "adds gap class" do
        expect(page).to have_selector(".where\\:gap-x-2")
      end

      it "adds gap class to parts" do
        expect(page).to have_selector(".countdown.where\\:gap-x-1")
      end
    end
  end

  context "with letters modifier" do
    let(:duration) { ActiveSupport::Duration.build(3725) }

    before do
      render_inline(described_class.new(duration: duration, modifier: :letters))
    end

    describe "rendering" do
      it "renders letter separators" do
        expect(page).to have_text("h")
        expect(page).to have_text("m")
        expect(page).to have_text("s")
      end
    end
  end

  context "with custom parts CSS" do
    let(:duration) { 60.seconds }
    let(:parts_css) { "custom-part" }

    before do
      render_inline(described_class.new(duration: duration, parts_css: parts_css))
    end

    describe "rendering" do
      it "applies custom CSS to parts" do
        expect(page).to have_selector(".countdown.#{parts_css}")
      end
    end
  end

  context "with custom parts HTML" do
    let(:duration) { 60.seconds }
    let(:title) { "Time remaining" }

    before do
      render_inline(described_class.new(duration: duration, parts_html: { title: title }))
    end

    describe "rendering" do
      it "applies custom HTML attributes to parts" do
        expect(page).to have_selector(".countdown[title='#{title}']")
      end
    end
  end

  context "with individual part customization" do
    let(:duration) { ActiveSupport::Duration.build(90061) } # 1d 1h 1m 1s
    let(:days_css) { "days-custom" }
    let(:hours_css) { "hours-custom" }
    let(:minutes_css) { "minutes-custom" }
    let(:seconds_css) { "seconds-custom" }

    before do
      render_inline(described_class.new(
        duration: duration,
        days_css: days_css,
        hours_css: hours_css,
        minutes_css: minutes_css,
        seconds_css: seconds_css
      ))
    end

    describe "rendering" do
      it "applies custom CSS to each part" do
        expect(page).to have_selector(".countdown.#{days_css}")
        expect(page).to have_selector(".countdown.#{hours_css}")
        expect(page).to have_selector(".countdown.#{minutes_css}")
        expect(page).to have_selector(".countdown.#{seconds_css}")
      end

      it "renders all time values correctly" do
        expect(page).to have_selector("[style*='--value: 1']", count: 4)
      end

      it "renders parts in correct order" do
        countdown_html = page.find(".flex").native.inner_html
        days_pos = countdown_html.index("days-custom")
        hours_pos = countdown_html.index("hours-custom")
        minutes_pos = countdown_html.index("minutes-custom")
        seconds_pos = countdown_html.index("seconds-custom")

        expect(days_pos).to be < hours_pos
        expect(hours_pos).to be < minutes_pos
        expect(minutes_pos).to be < seconds_pos
      end
    end
  end

  context "with stimulus targets" do
    let(:duration) { ActiveSupport::Duration.build(3725) }

    before do
      render_inline(described_class.new(duration: duration))
    end

    describe "rendering" do
      it "adds stimulus targets to parts" do
        expect(page).to have_selector("[data-loco-countdown-target='hours']")
        expect(page).to have_selector("[data-loco-countdown-target='minutes']")
        expect(page).to have_selector("[data-loco-countdown-target='seconds']")
      end
    end
  end
end
