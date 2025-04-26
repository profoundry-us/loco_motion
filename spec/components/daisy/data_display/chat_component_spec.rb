require "rails_helper"

RSpec.describe Daisy::DataDisplay::ChatComponent, type: :component do
  context "with no options" do
    before do
      render_inline(described_class.new)
    end

    describe "rendering" do
      it "renders the chat container" do
        expect(page).to have_selector(".chat")
      end

      it "defaults to chat-start" do
        expect(page).to have_selector(".chat-start")
      end
    end
  end

  context "with chat position" do
    context "with chat-end" do
      before do
        render_inline(described_class.new(css: "chat-end"))
      end

      it "renders with chat-end class" do
        expect(page).to have_selector(".chat.chat-end")
      end

      it "does not add chat-start" do
        expect(page).not_to have_selector(".chat-start")
      end
    end

    context "with chat-start" do
      before do
        render_inline(described_class.new(css: "chat-start"))
      end

      it "renders with chat-start class" do
        expect(page).to have_selector(".chat.chat-start")
      end
    end
  end

  context "with avatar" do
    let(:avatar_src) { "avatar.jpg" }

    before do
      render_inline(described_class.new) do |c|
        c.with_avatar(src: avatar_src)
      end
    end

    describe "rendering" do
      it "renders the avatar" do
        expect(page).to have_selector(".chat-image")
      end

      it "renders the avatar image" do
        expect(page).to have_selector(".chat-image img[src*='#{avatar_src}']")
      end
    end
  end

  context "with avatar icon" do
    before do
      render_inline(described_class.new) do |c|
        c.with_avatar(icon: "user")
      end
    end

    describe "rendering" do
      it "renders the avatar with icon" do
        expect(page).to have_selector(".chat-image")
        expect(page).to have_selector(".chat-image svg")
      end
    end
  end

  context "with header" do
    let(:header_text) { "Chat Header" }

    before do
      render_inline(described_class.new) do |c|
        c.with_header { header_text }
      end
    end

    describe "rendering" do
      it "renders the header" do
        expect(page).to have_selector(".chat-header", text: header_text)
      end
    end
  end

  context "with footer" do
    let(:footer_text) { "Seen at 10:45 AM" }

    before do
      render_inline(described_class.new) do |c|
        c.with_footer { footer_text }
      end
    end

    describe "rendering" do
      it "renders the footer" do
        expect(page).to have_selector(".chat-footer", text: footer_text)
      end
    end
  end

  context "with single bubble" do
    let(:bubble_text) { "Hello!" }

    before do
      render_inline(described_class.new) do |c|
        c.with_bubble { bubble_text }
      end
    end

    describe "rendering" do
      it "renders the bubble" do
        expect(page).to have_selector(".chat-bubble", text: bubble_text)
      end
    end
  end

  context "with multiple bubbles" do
    let(:bubble_texts) { ["Hello!", "How are you?"] }

    before do
      render_inline(described_class.new) do |c|
        bubble_texts.each do |text|
          c.with_bubble { text }
        end
      end
    end

    describe "rendering" do
      it "renders all bubbles" do
        bubble_texts.each do |text|
          expect(page).to have_selector(".chat-bubble", text: text)
        end
      end
    end
  end

  context "with custom bubble styles" do
    let(:bubble_class) { "chat-bubble-primary" }

    before do
      render_inline(described_class.new) do |c|
        c.with_bubble(css: bubble_class) { "Custom styled bubble" }
      end
    end

    describe "rendering" do
      it "includes custom bubble class" do
        expect(page).to have_selector(".chat-bubble.#{bubble_class}")
      end
    end
  end

  context "with colored chat" do
    let(:chat) { described_class.new }

    context "with primary color" do
      before do
        render_inline(chat) do |c|
          c.with_bubble(css: "chat-bubble-primary") do
            "Primary message"
          end
        end
      end

      describe "rendering" do
        it "applies primary color class" do
          expect(page).to have_selector(".chat-bubble.chat-bubble-primary")
        end

        it "renders the message" do
          expect(page).to have_text("Primary message")
        end
      end
    end

    context "with secondary color" do
      before do
        render_inline(chat) do |c|
          c.with_bubble(css: "chat-bubble-secondary") do
            "Secondary message"
          end
        end
      end

      describe "rendering" do
        it "applies secondary color class" do
          expect(page).to have_selector(".chat-bubble.chat-bubble-secondary")
        end

        it "renders the message" do
          expect(page).to have_text("Secondary message")
        end
      end
    end

    context "with accent color" do
      before do
        render_inline(chat) do |c|
          c.with_bubble(css: "chat-bubble-accent") do
            "Accent message"
          end
        end
      end

      describe "rendering" do
        it "applies accent color class" do
          expect(page).to have_selector(".chat-bubble.chat-bubble-accent")
        end

        it "renders the message" do
          expect(page).to have_text("Accent message")
        end
      end
    end

    context "with custom color" do
      before do
        render_inline(chat) do |c|
          c.with_bubble(css: "chat-bubble-info bg-blue-500 text-blue-50") do
            "Info message"
          end
        end
      end

      describe "rendering" do
        it "applies custom color classes" do
          expect(page).to have_selector(".chat-bubble.chat-bubble-info.bg-blue-500.text-blue-50")
        end

        it "renders the message" do
          expect(page).to have_text("Info message")
        end
      end
    end
  end

  context "with complex configuration" do
    let(:header_text) { "John Doe" }
    let(:bubble_text) { "Hey there!" }
    let(:footer_text) { "Sent at 10:45 AM" }
    let(:avatar_src) { "avatar.jpg" }

    before do
      render_inline(described_class.new(css: "chat-end")) do |c|
        c.with_avatar(src: avatar_src)
        c.with_header { header_text }
        c.with_bubble(css: "chat-bubble-primary") { bubble_text }
        c.with_footer { footer_text }
      end
    end

    describe "rendering" do
      it "renders all components in correct order" do
        chat_html = page.find(".chat").native.inner_html
        avatar_pos = chat_html.index("chat-image")
        header_pos = chat_html.index("chat-header")
        bubble_pos = chat_html.index("chat-bubble")
        footer_pos = chat_html.index("chat-footer")

        expect(avatar_pos).to be < header_pos
        expect(header_pos).to be < bubble_pos
        expect(bubble_pos).to be < footer_pos
      end

      it "renders the avatar" do
        expect(page).to have_selector(".chat-image img[src*='#{avatar_src}']")
      end

      it "renders the header" do
        expect(page).to have_selector(".chat-header", text: header_text)
      end

      it "renders the bubble with custom class" do
        expect(page).to have_selector(".chat-bubble.chat-bubble-primary", text: bubble_text)
      end

      it "renders the footer" do
        expect(page).to have_selector(".chat-footer", text: footer_text)
      end

      it "includes chat position class" do
        expect(page).to have_selector(".chat.chat-end")
      end
    end
  end
end
