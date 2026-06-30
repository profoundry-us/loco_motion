# frozen_string_literal: true

require "rails_helper"
require "fileutils"

# Test class that includes the concern
class IconableTestComponent < LocoMotion::BaseComponent
  include LocoMotion::Concerns::IconableComponent

  def call
    content = ""
    content += helpers.heroicon(@left_icon, **left_icon_html) if @left_icon
    content += "Test Content"
    content += helpers.heroicon(@right_icon, **right_icon_html) if @right_icon
    part(:component) { content.html_safe }
  end

  def before_render
    setup_component
    super
  end

  def setup_component
    set_tag_name(:component, :div)
    add_css(:component, "test-component")
  end
end

RSpec.describe LocoMotion::Concerns::IconableComponent, type: :component do
  context "with no icons" do
    before do
      render_inline(IconableTestComponent.new)
    end

    it "renders without icon classes" do
      expect(page).to have_css("div.test-component")
      expect(page).not_to have_css('.where\\:inline-flex')
      expect(page).not_to have_css("svg")
    end

    it "reports no icons present" do
      component = IconableTestComponent.new
      expect(component.has_icons?).to be_falsey
    end
  end

  context "with left icon" do
    before do
      render_inline(IconableTestComponent.new(left_icon: "star"))
    end

    it "adds flex classes for proper icon alignment" do
      expect(page).to have_css('.where\\:inline-flex.where\\:items-center.where\\:gap-2')
    end

    it "renders the icon" do
      expect(page).to have_css("svg")
    end

    it "reports icons present" do
      component = IconableTestComponent.new(left_icon: "star")
      expect(component.has_icons?).to be_truthy
    end
  end

  context "with right icon" do
    before do
      render_inline(IconableTestComponent.new(right_icon: "arrow-right"))
    end

    it "adds flex classes for proper icon alignment" do
      expect(page).to have_css('.where\\:inline-flex.where\\:items-center.where\\:gap-2')
    end

    it "renders the icon" do
      expect(page).to have_css("svg")
    end
  end

  context "with both left and right icons" do
    before do
      render_inline(IconableTestComponent.new(
                      left_icon: "star",
                      right_icon: "arrow-right"
                    ))
    end

    it "renders both icons" do
      expect(page).to have_css("svg", count: 2)
    end
  end

  context "with icon alias" do
    before do
      render_inline(IconableTestComponent.new(icon: "star"))
    end

    it "uses the icon as left_icon" do
      expect(page).to have_css("svg")
    end
  end

  context "with custom icon classes" do
    before do
      render_inline(IconableTestComponent.new(
                      left_icon: "star",
                      left_icon_css: "text-blue-500 size-6"
                    ))
    end

    it "applies custom CSS classes to the icon" do
      expect(page).to have_css("svg.text-blue-500.size-6")
    end
  end

  context "with custom icon HTML attributes" do
    let(:component) { IconableTestComponent.new(left_icon: "star", left_icon_html: { data: { test: "value" } }) }

    it "properly builds the HTML attributes hash" do
      # Test the actual helper method that builds the attributes hash
      attrs = component.left_icon_html
      expect(attrs).to include(data: { test: "value" })
    end

    # We don't need to test the actual rendering since that depends on the heroicon helper
    # which is tested separately
  end

  context "with icon_options" do
    let(:component) { IconableTestComponent.new(icon: "star", icon_options: { variant: "solid" }) }

    it "defaults left_icon_options to icon_options" do
      # When icon_options is provided, it should be used as the default for left_icon_options
      # This is tested indirectly through the render_left_icon method which uses @left_icon_options
      expect(component.instance_variable_get(:@left_icon_options)).to eq({ variant: "solid" })
    end
  end

  context "with left_icon_options" do
    let(:component) { IconableTestComponent.new(left_icon: "star", left_icon_options: { variant: "solid" }) }

    it "uses the provided left_icon_options" do
      expect(component.instance_variable_get(:@left_icon_options)).to eq({ variant: "solid" })
    end
  end

  # These exercise render_left_icon/render_right_icon (the actual render path)
  # through a real component, covering the library dual-path: Heroicons render
  # via rails_heroicon, other libraries via the loco_icon engine.
  describe "the render path (via ButtonComponent)" do
    context "with a default Heroicons icon" do
      before { render_inline(Daisy::Actions::ButtonComponent.new(icon: "x-mark")) }

      it "renders an inline svg" do
        expect(page).to have_css("button svg")
      end
    end

    context "with a synced non-Heroicons library" do
      let(:svg_dir) { Rails.root.join("app/assets/svg/icons/testlib/outline") }

      before do
        FileUtils.mkdir_p(svg_dir)
        File.write(
          svg_dir.join("star.svg"),
          %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" ) +
            %(data-source="testlib"><path d="M0 0"/></svg>)
        )
        render_inline(
          Daisy::Actions::ButtonComponent.new(icon: "testlib:star")
        )
      end

      after { FileUtils.rm_rf(Rails.root.join("app/assets/svg/icons/testlib")) }

      it "renders the icon from the synced library via the engine" do
        expect(page).to have_css("button svg")
        expect(page.native.to_html).to include('data-source="testlib"')
      end
    end

    context "with an unsynced non-Heroicons library" do
      it "raises a clear error" do
        expect do
          render_inline(Daisy::Actions::ButtonComponent.new(icon: "not_installed:star"))
        end.to raise_error(LocoMotion::Icons::IconNotFound)
      end
    end
  end
end
