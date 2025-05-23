# frozen_string_literal: true

require 'algoliasearch-rails'

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

    # Configure the index settings if the index does not exist
    #
    # @return [void]
    #
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
    # @return [String] The full index name (including LocoMotion version)
    #
    def index_name(name)
      env = ENV['ALGOLIA_ENV'] || Rails.env
      "loco_motion_#{env}_#{name}_#{LocoMotion::VERSION}"
    end

    # Default settings for Algolia indices.
    #
    # @return [Hash] Default index settings
    #
    def default_index_settings
      {
        searchable_attributes: [
          'title',
          'description',
          'framework',
          'section',
          'component',
          'code'
        ],
        attributes_for_faceting: [
          'filterOnly(framework)',
          'filterOnly(section)'
        ],
        custom_ranking: [
          'asc(priority)',
          'asc(title)'
        ],
        highlight_pre_tag: '<em class="highlight">',
        highlight_post_tag: '</em>'
      }
    end
  end
end
