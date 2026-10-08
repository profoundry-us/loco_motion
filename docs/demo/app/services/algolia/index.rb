# frozen_string_literal: true

require "algoliasearch-rails"

module Algolia
  # Handles configuration and access to the Algolia API.
  #
  # This class provides a simplified interface for interacting with Algolia
  # indices, including initializing the client, configuring indices, and
  # performing batch operations.
  #
  # @loco_example Initialize and use an index
  #   index = Algolia::Index.new('components')
  #   index.save_objects(records)
  #   index.clear_objects
  #
  class Index
    DEFAULT_INDEX = "components"

    # Search results tie-break by group, then by position within the group
    # (component or page order), then by index within that position (example or
    # section order). Each is its own ranking attribute, so no group, page, or
    # section count can push a record past the next group.
    RANK_GROUPS = { component: 0, doc: 1, guide: 2, example: 3 }.freeze

    attr_reader :name

    # Initialize a new Algolia index.
    #
    # @param short_name [String] The base name of the index
    #
    def initialize(short_name)
      @name = index_name(short_name)

      configure_client
      configure_index
    end

    # Saves multiple records in one batch request
    #
    # @param records [Array<Hash>] Array of records to save
    # @return [Algolia::Search::SaveObjectsResponse] The Algolia response
    #
    def save_objects(records)
      requests = records.map do |record|
        Algolia::Search::BatchRequest.new(action: "addObject", body: record)
      end

      @client.batch(@name, Algolia::Search::BatchWriteParams.new(
                             requests: requests
                           ))
    end

    # Clears all objects from the index
    #
    # @return [Algolia::Search::Response] The Algolia response
    #
    def clear_objects
      @client.clear_objects(@name)
    end

    private

    # Configure the Algolia client with credentials.
    #
    # @return [void]
    #
    def configure_client
      @client = AlgoliaSearch.client
    end

    # Apply the index settings on every run. Settings are idempotent, and an
    # index created by an earlier release would otherwise keep ranking on
    # attributes its records no longer carry.
    #
    # @return [void]
    #
    def configure_index
      @client.set_settings(@name, Algolia::Search::IndexSettings.new(default_index_settings), true)
    end

    # Generate the full index name including environment prefix.
    #
    # @param name [String] The base name of the index
    # @return [String] The full index name (including LocoMotion version)
    #
    def index_name(name)
      env = ENV["ALGOLIA_ENV"] || Rails.env
      "loco_motion_#{env}_#{name}_#{LocoMotion::VERSION}"
    end

    # Default settings for Algolia indices.
    #
    # @return [Hash] Default index settings
    #
    def default_index_settings
      {
        searchable_attributes: %w[
          title
          description
          framework
          section
          component
          code
        ],
        attributes_for_faceting: [
          "filterOnly(framework)",
          "filterOnly(section)"
        ],
        custom_ranking: [
          "asc(rank_group)",
          "asc(rank_position)",
          "asc(rank_index)",
          "asc(title)"
        ],
        highlight_pre_tag: '<em class="highlight">',
        highlight_post_tag: "</em>"
      }
    end
  end
end
