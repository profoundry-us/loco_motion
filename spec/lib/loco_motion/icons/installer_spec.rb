# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"
require "icons"

RSpec.describe LocoMotion::Icons::Installer do
  around do |example|
    Dir.mktmpdir do |dir|
      @target = dir
      example.run
    end
  end

  # Stub the icons gem's network clone with one that writes a marker SVG into
  # the configured target, mirroring how Icons::Sync moves a library into place.
  def stub_sync_writing(filename)
    allow(::Icons::Sync).to receive(:new) do |library|
      instance_double(::Icons::Sync).tap do |sync|
        allow(sync).to receive(:now) do
          dir = File.join(@target, library.to_s, "outline")
          FileUtils.mkdir_p(dir)
          File.write(File.join(dir, filename), "<svg></svg>")
        end
      end
    end
  end

  describe ".add" do
    it "returns the synced library names" do
      stub_sync_writing("icon.svg")

      expect(described_class.add(%w[heroicons lucide], target: @target)).to eq(%w[heroicons lucide])
    end

    it "clears an existing library directory first, so a re-sync actually refreshes it" do
      stale = File.join(@target, "heroicons", "outline", "stale.svg")
      FileUtils.mkdir_p(File.dirname(stale))
      File.write(stale, "<svg></svg>")

      stub_sync_writing("fresh.svg")
      described_class.add(["heroicons"], target: @target)

      expect(File.exist?(stale)).to be(false)
      expect(File.exist?(File.join(@target, "heroicons", "outline", "fresh.svg"))).to be(true)
    end
  end
end
