# frozen_string_literal: true

require "rails_helper"

RSpec.describe Algolia::PageMetadataExtractor do
  let(:extractor) { described_class.new }

  # Extraction renders every real page, so run it once for the whole group.
  let(:records) { @records }

  before(:all) do
    @records = described_class.new.extract_all
  end

  describe "#extract_all" do
    it "produces records for both docs and guide pages" do
      expect(records.map { |r| r[:type] }.uniq).to contain_exactly("doc", "guide")
    end

    it "skips partials" do
      expect(records.map { |r| r[:objectID] }).to all(satisfy { |id| !id.include?("_wip") })
    end

    it "creates one record per h2 section with an anchor deep-link" do
      record = records.find { |r| r[:objectID] == "guide-08_authentication-omniauth" }

      expect(record).to include(
        type: "guide",
        section: "Guides",
        url: "/guides/08_authentication#omniauth",
        page_title: "Authentication"
      )
      expect(record[:title]).to eq("Authentication with OmniAuth")
      expect(record[:description]).to be_present
    end

    it "tags docs pages with the doc type and Docs section" do
      record = records.find { |r| r[:objectID] == "doc-03_install-tailwind" }

      expect(record).to include(
        type: "doc",
        section: "Docs",
        url: "/docs/03_install#tailwind"
      )
    end

    it "creates a page-level intro record without a fragment" do
      record = records.find { |r| r[:objectID] == "guide-08_authentication-intro" }

      expect(record[:url]).to eq("/guides/08_authentication")
      expect(record[:title]).to eq("Authentication")
    end

    it "keeps descriptions to prose capped at the word limit" do
      records.each do |record|
        expect(record[:description].split(/\s+/).size)
          .to be <= described_class::DESCRIPTION_WORDS
        expect(record[:description]).not_to match(/\A\s|\s\z/)
      end
    end

    it "ranks pages between components (1..~60) and examples (1000+)" do
      priorities = records.map { |r| r[:priority] }

      expect(priorities.min).to be >= 500
      expect(priorities.max).to be < 1000
    end

    it "ranks docs pages above guides" do
      doc_max = records.select { |r| r[:type] == "doc" }.map { |r| r[:priority] }.max
      guide_min = records.select { |r| r[:type] == "guide" }.map { |r| r[:priority] }.min

      expect(doc_max).to be < guide_min
    end

    it "uses stable objectIDs derived from page and anchor" do
      expect(records.map { |r| r[:objectID] }.uniq.size).to eq(records.size)
    end
  end
end
