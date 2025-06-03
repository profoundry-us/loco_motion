require "rails_helper"

RSpec.describe Daisy::DataDisplay::AvatarComponent, type: :component do
  context "basic avatar" do
    let(:avatar) { described_class.new }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "has the avatar class" do
        expect(page).to have_selector(".avatar")
      end

      it "has default wrapper classes" do
        expect(page).to have_selector(".avatar [class*=':w-24'][class*=':rounded-full']")
      end

      it "has placeholder classes when no image is provided" do
        expect(page).to have_selector(".avatar.avatar-placeholder")
        expect(page).to have_selector("[class*=':bg-neutral'][class*=':text-neutral-content']")
      end
    end
  end

  context "with image" do
    let(:src) { "https://example.com/avatar.jpg" }
    let(:alt_text) { "User Avatar" }
    let(:avatar) { described_class.new(src: src) { alt_text } }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "renders an img tag" do
        expect(page).to have_selector(".avatar img[src='#{src}']")
      end

      it "does not have placeholder classes" do
        expect(page).not_to have_selector(".avatar.avatar-placeholder")
        expect(page).not_to have_selector("[class*=':bg-neutral']")
      end
    end
  end

  context "with icon" do
    let(:icon) { "user" }
    let(:icon_css) { "text-sky-400" }
    let(:avatar) { described_class.new(icon: icon, icon_css: icon_css) }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "renders the icon" do
        expect(page).to have_selector(".avatar svg")
      end

      it "applies icon CSS classes" do
        expect(page).to have_selector(".avatar svg.text-sky-400")
      end

      it "has placeholder classes" do
        expect(page).to have_selector(".avatar.avatar-placeholder")
      end
    end
  end

  context "with placeholder text" do
    let(:text) { "AB" }

    before do
      render_inline(described_class.new) { text }
    end

    describe "rendering" do
      it "renders the text" do
        expect(page).to have_selector(".avatar", text: text)
      end

      it "has placeholder classes" do
        expect(page).to have_selector(".avatar.avatar-placeholder")
      end
    end
  end

  context "with online status" do
    let(:avatar) { described_class.new(css: "avatar-online") }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "includes online class" do
        expect(page).to have_selector(".avatar.avatar-online")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".avatar")
      end
    end
  end

  context "with offline status" do
    let(:avatar) { described_class.new(css: "avatar-offline") }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "includes offline class" do
        expect(page).to have_selector(".avatar.avatar-offline")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".avatar")
      end
    end
  end

  context "with custom size" do
    let(:size_classes) { "w-10 h-10" }
    let(:avatar) { described_class.new(css: size_classes) }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "includes size classes" do
        expect(page).to have_selector(".avatar.size-10")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".avatar")
      end
    end
  end

  context "with tooltip" do
    let(:tip) { "User avatar" }
    let(:avatar) { described_class.new(tip: tip) }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "includes tooltip class" do
        expect(page).to have_selector(".avatar.tooltip")
      end

      it "sets data-tip attribute" do
        expect(page).to have_css("[data-tip=\"#{tip}\"]")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".avatar")
      end
    end
  end

  context "with complex configuration" do
    let(:src) { "https://example.com/avatar.jpg" }
    let(:alt_text) { "User Avatar" }
    let(:size_classes) { "w-16 h-16" }
    let(:avatar) { described_class.new(src: src, css: "#{size_classes} avatar-online", tip: "Online User") { alt_text } }

    before do
      render_inline(avatar)
    end

    describe "rendering" do
      it "renders the image" do
        expect(page).to have_selector(".avatar img[src='#{src}']")
      end

      it "includes all classes" do
        expect(page).to have_selector(".avatar.size-16.avatar-online.tooltip")
      end

      it "sets the tooltip" do
        expect(page).to have_css("[data-tip=\"Online User\"]")
      end

      it "maintains default classes" do
        expect(page).to have_selector(".avatar")
      end
    end
  end
end
