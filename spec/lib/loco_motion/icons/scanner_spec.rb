# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"

RSpec.describe LocoMotion::Icons::Scanner do
  around do |example|
    Dir.mktmpdir do |dir|
      @root = dir
      example.run
    end
  end

  def write(name, contents)
    path = File.join(@root, name)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
  end

  def references(paths: ["**/*.{haml,rb}"], default_library: "heroicons")
    described_class.new(paths: paths, root: @root, default_library: default_library).references
  end

  describe "#references" do
    it "finds the first string argument of a loco_icon / hero_icon call" do
      write("app/views/a.haml", <<~HAML)
        = loco_icon("academic-cap")
        = hero_icon "archive-box"
        = loco_icon('beaker')
      HAML

      names = references.map { |r| r[:name] }
      expect(names).to contain_exactly("academic-cap", "archive-box", "beaker")
      expect(references).to all(include(library: "heroicons", variant: nil))
    end

    it "finds names passed via icon: / left_icon: / right_icon: / middle_icon:" do
      write("app/views/b.haml", <<~HAML)
        = daisy_button("Go", icon: "arrow-right")
        = daisy_button(left_icon: "cloud", right_icon: "folder")
        = daisy_timeline_event(middle_icon: "check-circle")
      HAML

      expect(references.map { |r| r[:name] }).to contain_exactly(
        "arrow-right", "cloud", "folder", "check-circle"
      )
    end

    it "does not confuse the icon: matcher with *_icon_css / *_icon_options keys" do
      write("app/views/c.haml", <<~HAML)
        = daisy_button(icon: "star", right_icon_css: "size-4", left_icon_options: { variant: :solid })
      HAML

      expect(references.map { |r| r[:name] }).to contain_exactly("star")
    end

    it "captures an explicit library and variant on the same line" do
      write("app/views/d.haml", <<~HAML)
        = loco_icon("heart", library: :lucide)
        = loco_icon("bolt", variant: :solid)
        = daisy_button(icon: "gear", icon_library: "phosphor", icon_variant: :bold)
      HAML

      expect(references).to contain_exactly(
        { library: "lucide", variant: nil, name: "heart" },
        { library: "heroicons", variant: "solid", name: "bolt" },
        { library: "phosphor", variant: "bold", name: "gear" }
      )
    end

    it "treats variant: nil as no variant" do
      write("app/views/e.haml", %(= loco_icon("home", library: :feather, variant: nil)\n))

      expect(references).to contain_exactly(library: "feather", variant: nil, name: "home")
    end

    it "ignores dynamically-built names it cannot resolve statically" do
      write("app/views/f.haml", <<~HAML)
        = loco_icon("bars-\#{i}")
        = loco_icon(section[:icon])
        = daisy_button(icon: some_variable)
      HAML

      expect(references).to be_empty
    end

    it "skips Ruby comment lines (YARD examples) but scans HAML id lines" do
      write("app/components/widget.rb", <<~RUBY)
        # @loco_example
        #   = hero_icon("should-be-ignored")
        ICON = "not-an-icon-call"
      RUBY
      write("app/views/g.haml", %(#sidebar= loco_icon("real-icon")\n))

      names = references.map { |r| r[:name] }
      expect(names).to include("real-icon")
      expect(names).not_to include("should-be-ignored")
    end

    it "returns unique references in a deterministic, sorted order" do
      write("app/views/h.haml", <<~HAML)
        = loco_icon("zebra")
        = loco_icon("apple")
        = loco_icon("apple")
        = loco_icon("mango", library: :lucide)
      HAML

      expect(references).to eq([
                                 { library: "heroicons", variant: nil, name: "apple" },
                                 { library: "heroicons", variant: nil, name: "zebra" },
                                 { library: "lucide", variant: nil, name: "mango" }
                               ])
    end
  end

  describe ".parse_safelist" do
    it "parses name, library:name, and library:name:variant forms" do
      result = described_class.parse_safelist(
        ["information-circle", "lucide:heart", "phosphor:gear:bold"],
        default_library: "heroicons"
      )

      expect(result).to eq([
                             { library: "heroicons", variant: nil, name: "information-circle" },
                             { library: "lucide", variant: nil, name: "heart" },
                             { library: "phosphor", variant: "bold", name: "gear" }
                           ])
    end

    it "returns an empty array for nil / empty input" do
      expect(described_class.parse_safelist(nil, default_library: "heroicons")).to eq([])
    end
  end
end
