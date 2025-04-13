RSpec.describe Daisy::DataDisplay::StatusComponent, type: :component do
  it "renders basic component" do
    render_inline(described_class.new)
    expect(page).to have_css(".status")
  end

  context "with custom HTML attributes" do
    it "passes attributes to the component" do
      render_inline(described_class.new(html: { id: "custom-status", data: { test: "value" } }))
      expect(page).to have_css(".status#custom-status[data-test='value']")
    end

    it "applies custom classes" do
      render_inline(described_class.new(css: "status-primary status-lg"))
      expect(page).to have_css(".status.status-primary.status-lg")
    end

    it "applies aria attributes" do
      render_inline(described_class.new(html: { aria: { label: "Status: Online" } }))
      expect(page).to have_css(".status[aria-label='Status: Online']")
    end
  end

  context "with different sizes" do
    %w[xs sm md lg xl].each do |size|
      it "renders #{size} size" do
        render_inline(described_class.new(css: "status-#{size}"))
        expect(page).to have_css(".status.status-#{size}")
      end
    end
  end

  context "with different colors" do
    %w[primary secondary accent neutral info success warning error].each do |color|
      it "renders #{color} color" do
        render_inline(described_class.new(css: "status-#{color}"))
        expect(page).to have_css(".status.status-#{color}")
      end
    end
  end
end
