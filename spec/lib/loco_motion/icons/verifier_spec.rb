# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"

RSpec.describe LocoMotion::Icons::Verifier do
  around do |example|
    Dir.mktmpdir do |vendored|
      Dir.mktmpdir do |bundled|
        @vendored = vendored
        @bundled = bundled
        example.run
      end
    end
  end

  # Populate a fake icon root (the vendored set or the engine's bundled set).
  def icon(root, library, variant, name)
    parts = [library, variant, "#{name}.svg"].compact
    path = File.join(root, *parts)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, %(<svg data-name="#{name}"></svg>))
  end

  def verify(references, default_variant: "outline")
    described_class.new(roots: [@vendored, @bundled], default_variant: default_variant)
                   .verify(references)
  end

  it "verifies references that resolve from the vendored set, using the default variant" do
    icon(@vendored, "heroicons", "outline", "star")

    result = verify([{ library: "heroicons", variant: nil, name: "star" }])

    expect(result.verified).to eq(1)
    expect(result.missing).to be_empty
  end

  it "verifies references that resolve only from the bundled set" do
    icon(@bundled, "heroicons", "outline", "x-mark")

    result = verify([{ library: "heroicons", variant: nil, name: "x-mark" }])

    expect(result.verified).to eq(1)
    expect(result.missing).to be_empty
  end

  it "honors an explicit variant instead of the default" do
    icon(@vendored, "heroicons", "outline", "bolt")

    result = verify([{ library: "heroicons", variant: "solid", name: "bolt" }])

    expect(result.missing).to eq([{ library: "heroicons", variant: "solid", name: "bolt" }])
  end

  it "supports flat libraries (nil variant collapses the path)" do
    icon(@vendored, "flags", nil, "us")

    result = verify([{ library: "flags", variant: nil, name: "us" }], default_variant: nil)

    expect(result.verified).to eq(1)
    expect(result.missing).to be_empty
  end

  it "reports references that resolve from no root" do
    icon(@vendored, "heroicons", "outline", "star")

    result = verify([
                      { library: "heroicons", variant: nil, name: "star" },
                      { library: "heroicons", variant: nil, name: "not-vendored" }
                    ])

    expect(result.verified).to eq(1)
    expect(result.missing).to eq([{ library: "heroicons", variant: nil, name: "not-vendored" }])
  end
end
