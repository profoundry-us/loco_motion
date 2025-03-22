# frozen_string_literal: true

require 'algoliasearch-rails'

module Algolia
  # Handles configuration and access to the Algolia API.
  class Index
    attr_reader :name

    # Initialize a new Algolia index.
    def initialize(short_name)
      @name = index_name(short_name)

      configure_client
      configure_index
    end

    # Saves multiple records in one batch request
    #
    # @param records [Array<Hash>]
    def save_objects(records)
      requests = records.map do |record|
        Algolia::Search::BatchRequest.new(action: "addObject", body: record)
      end

      @client.batch(@name, Algolia::Search::BatchWriteParams.new(
        requests: requests
      ))
    end

    # Clears all objects from the index
    def clear_objects
      @client.clear_objects(@name)
    end

    private

    # Configure the Algolia client with credentials.
    def configure_client
      @client = AlgoliaSearch.client
    end

    def configure_index
      indices = @client.list_indices
      index_exists = indices&.items&.map(&:name)&.include?(@name)

      if !index_exists
        @client.set_settings(@name, Algolia::Search::IndexSettings.new(default_index_settings), true)
      end
    end

    # Generate the full index name including environment prefix.
    #
    # @param name [String] The base name of the index
    # @return [String] The full index name
    def index_name(name)
      "loco_motion_#{Rails.env}_#{name}"
    end

    # Default settings for Algolia indices.
    #
    # @return [Hash] Default index settings
    def default_index_settings
      {
        searchable_attributes: [
          'title',
          'group',
          'helper_names',
          'description',
          'example_code'
        ],
        attributes_for_faceting: [
          'filterOnly(group)'
        ],
        custom_ranking: [
          'desc(popularity)',
          'asc(title)'
        ],
        highlight_pre_tag: '<em class="highlight">',
        highlight_post_tag: '</em>'
      }
    end
  end
end
