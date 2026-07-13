# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocNoteComponent, type: :component do
  it "renders an informational note by default" do
    render_inline(described_class.new) { "Read the docs first." }

    expect(page).to have_css(".alert.border-info.bg-info\\/10")
    expect(page).to have_css("svg.text-info")
    expect(page).to have_text("Note")
    expect(page).to have_text("Read the docs first.")
  end

  {
    tip: { title: "Tip", color: "success" },
    todo: { title: "Todo", color: "accent" },
    warning: { title: "Warning", color: "warning" },
    error: { title: "Error", color: "error" }
  }.each do |modifier, expected|
    it "renders the #{modifier} modifier with its own color and title" do
      render_inline(described_class.new(modifier: modifier)) { "Body text." }

      expect(page).to have_css(
        ".alert.border-#{expected[:color]}.bg-#{expected[:color]}\\/10"
      )
      expect(page).to have_css("svg.text-#{expected[:color]}")
      expect(page).to have_text(expected[:title])
      expect(page).not_to have_text("Note")
    end
  end

  it "allows overriding the title" do
    render_inline(described_class.new(title: "Heads Up")) { "Body text." }

    expect(page).to have_text("Heads Up")
    expect(page).not_to have_text("Note")
  end

  it "allows overriding the icon while keeping the modifier's color" do
    render_inline(described_class.new(icon: "check-circle")) { "Body text." }

    expect(page).to have_css("svg.text-info")
  end

  it "keeps the content cell shrinkable so wide code can scroll" do
    render_inline(described_class.new) { "Body text." }

    expect(page).to have_css(".alert .min-w-0.justify-self-stretch")
  end
end
