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
        url: "/guides/authentication#omniauth",
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
        url: "/docs/install#tailwind"
      )
    end

    it "creates a page-level intro record without a fragment" do
      record = records.find { |r| r[:objectID] == "guide-08_authentication-intro" }

      expect(record[:url]).to eq("/guides/authentication")
      expect(record[:title]).to eq("Authentication")
    end

    it "keeps descriptions to prose capped at the word limit" do
      records.each do |record|
        expect(record[:description].split(/\s+/).size)
          .to be <= described_class::DESCRIPTION_WORDS
        expect(record[:description]).not_to match(/\A\s|\s\z/)
      end
    end

    it "ranks docs pages above guides" do
      groups = records.group_by { |r| r[:type] }.transform_values { |rs| rs.map { |r| r[:rank_group] }.uniq }

      expect(groups).to eq(
        "doc" => [Algolia::Index::RANK_GROUPS[:doc]],
        "guide" => [Algolia::Index::RANK_GROUPS[:guide]]
      )
      expect(Algolia::Index::RANK_GROUPS[:doc]).to be < Algolia::Index::RANK_GROUPS[:guide]
    end

    it "ranks each source's records by page and then by section" do
      records.group_by { |r| r[:type] }.each_value do |source_records|
        ranks = source_records.map { |r| [r[:rank_position], r[:rank_index]] }

        expect(ranks).to eq(ranks.sort)
        expect(ranks.uniq.size).to eq(ranks.size)
      end
    end

    it "uses stable objectIDs derived from page and anchor" do
      expect(records.map { |r| r[:objectID] }.uniq.size).to eq(records.size)
    end
  end
end
