# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocFlairComponent, type: :component do
  it "absolutely positions the flair at the given position" do
    render_inline(described_class.new(pos: "top-10 left-4")) { "Flair" }

    expect(page).to have_css(".absolute.top-10.left-4", text: "Flair")
  end

  it "wires up the parallax data attributes by default" do
    render_inline(described_class.new) { "Flair" }

    expect(page).to have_css(
      "[data-parallax-speed='0.5'][data-parallax-drift='0']" \
      "[data-parallax-rot='0']"
    )
  end

  it "accepts custom speed, drift, and rotation" do
    render_inline(described_class.new(speed: 1.2, drift: 40, rot: -12)) do
      "Flair"
    end

    expect(page).to have_css(
      "[data-parallax-speed='1.2'][data-parallax-drift='40']" \
      "[data-parallax-rot='-12']"
    )
  end

  it "hides the flair below the md breakpoint by default" do
    render_inline(described_class.new) { "Flair" }

    expect(page).to have_css(".hidden.md\\:block")
  end

  it "hides the flair below the lg breakpoint when show is 'lg'" do
    render_inline(described_class.new(show: "lg")) { "Flair" }

    expect(page).to have_css(".hidden.lg\\:block")
    expect(page).not_to have_css(".md\\:block")
  end

  it "springs into view instead of parallaxing in pop mode" do
    render_inline(described_class.new(pop: true, rot: 6)) { "Flair" }

    expect(page).to have_css("[data-pop='true'][data-pop-rot='6']")
    expect(page).to have_css(".opacity-0")
    expect(page).not_to have_css("[data-parallax-speed]")
  end
end
