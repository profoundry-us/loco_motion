# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"

RSpec.describe LocoMotion::Icons::Vendorer do
  around do |example|
    Dir.mktmpdir do |src|
      Dir.mktmpdir do |tgt|
        @source = src
        @target = tgt
        example.run
      end
    end
  end

  # Populate the fake "fully synced" source tree.
  def source_icon(library, variant, name)
    parts = [library, variant, "#{name}.svg"].compact
    path = File.join(@source, *parts)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, %(<svg data-name="#{name}"></svg>))
  end

  def target_files
    Dir.glob(File.join(@target, "**", "*.svg")).map { |p| p.sub("#{@target}/", "") }.sort
  end

  def vendor(references, default_variant: "outline")
    described_class.new(source: @source, target: @target, default_variant: default_variant)
                   .vendor(references)
  end

  it "copies only the referenced icons, resolving the default variant" do
    source_icon("heroicons", "outline", "star")
    source_icon("heroicons", "outline", "heart")
    source_icon("heroicons", "solid", "star")

    result = vendor([{ library: "heroicons", variant: nil, name: "star" }])

    expect(target_files).to eq(["heroicons/outline/star.svg"])
    expect(result.vendored).to eq(1)
    expect(result.missing).to be_empty
  end

  it "honors an explicit variant" do
    source_icon("heroicons", "solid", "bolt")

    vendor([{ library: "heroicons", variant: "solid", name: "bolt" }])

    expect(target_files).to eq(["heroicons/solid/bolt.svg"])
  end

  it "supports flat libraries (nil variant collapses the path)" do
    source_icon("feather", nil, "home")

    vendor([{ library: "feather", variant: nil, name: "home" }], default_variant: nil)

    expect(target_files).to eq(["feather/home.svg"])
  end

  it "prunes icons in a referenced library that are no longer referenced" do
    source_icon("heroicons", "outline", "star")
    source_icon("heroicons", "outline", "heart")
    # Pre-existing vendored icon that should be pruned on re-sync.
    FileUtils.mkdir_p(File.join(@target, "heroicons", "outline"))
    File.write(File.join(@target, "heroicons", "outline", "stale.svg"), "<svg></svg>")

    vendor([{ library: "heroicons", variant: nil, name: "star" }])

    expect(target_files).to eq(["heroicons/outline/star.svg"])
  end

  it "leaves unreferenced libraries untouched" do
    source_icon("heroicons", "outline", "star")
    FileUtils.mkdir_p(File.join(@target, "lucide"))
    File.write(File.join(@target, "lucide", "kept.svg"), "<svg></svg>")

    vendor([{ library: "heroicons", variant: nil, name: "star" }])

    expect(target_files).to include("lucide/kept.svg", "heroicons/outline/star.svg")
  end

  it "reports references whose source SVG is missing" do
    source_icon("heroicons", "outline", "star")

    result = vendor([
                      { library: "heroicons", variant: nil, name: "star" },
                      { library: "heroicons", variant: nil, name: "does-not-exist" }
                    ])

    expect(result.vendored).to eq(1)
    expect(result.missing).to eq([{ library: "heroicons", variant: nil, name: "does-not-exist" }])
  end
end
