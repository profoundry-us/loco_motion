# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocFigureComponent, type: :component do
  it "renders the image linked to the full-size source by default" do
    render_inline(described_class.new(src: "/images/shot.png", alt: "A shot"))

    expect(page).to have_css(
      "a[href='/images/shot.png'][target='_blank'] " \
      "img[src='/images/shot.png'][alt='A shot']"
    )
  end

  it "links the figure to a custom href when given" do
    render_inline(
      described_class.new(
        src: "/images/shot.png", alt: "A shot", href: "/images/full.png"
      )
    )

    expect(page).to have_css(
      "a[href='/images/full.png'] img[src='/images/shot.png']"
    )
  end

  it "renders the alt text as an italic caption below the figure" do
    render_inline(described_class.new(src: "/images/shot.png", alt: "A shot"))

    expect(page).to have_css(".mt-2.text-center.italic", text: "A shot")
  end

  it "wraps the image in a bordered, shadowed box" do
    render_inline(described_class.new(src: "/images/shot.png", alt: "A shot"))

    expect(page).to have_css(".border.border-base-300.shadow-lg img")
  end

  it "accepts additional CSS on the outer wrapper" do
    render_inline(
      described_class.new(src: "/images/shot.png", alt: "A shot", css: "my-8")
    )

    expect(page).to have_css("div.my-8 img")
  end

  it "requires src and alt" do
    expect { described_class.new(src: "/images/shot.png") }
      .to raise_error(ArgumentError)
    expect { described_class.new(alt: "A shot") }
      .to raise_error(ArgumentError)
  end
end
