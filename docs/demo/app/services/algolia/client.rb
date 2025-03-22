# frozen_string_literal: true

require 'algoliasearch-rails'

module Algolia
  # Handles configuration and access to the Algolia API.
  #
  # @example
  #   client = Algolia::Client.new
  #   index = client.index('components')
  #   index.add_objects([{ name: 'Component' }])
  class Client
    # Initialize a new Algolia client.
    #
    # @param application_id [String] Algolia application ID
    # @param api_key [String] Algolia API key
    #
    # @option options [Hash] :index_settings Settings to apply to indices
    def initialize(application_id = nil, api_key = nil, options = {})
      @application_id = application_id || ENV['ALGOLIA_APPLICATION_ID']
      @api_key = api_key || ENV['ALGOLIA_API_KEY']
      @index_settings = options[:index_settings] || default_index_settings

      configure_client
    end

    # Get an Algolia index by name.
    #
    # @param name [String] The name of the index
    # @return [Algolia::Index] The Algolia index
    def index(name)
      index = @client.init_index(index_name(name))
      index.set_settings(@index_settings)
      index
    end

    private

    # Configure the Algolia client with credentials.
    def configure_client
      @client = ::Algolia::Search::Client.create(@application_id, @api_key)
      # Note: We don't need to set AlgoliaSearch.client anymore as we're using the direct client
    end

    # Generate the full index name including environment prefix.
    #
    # @param name [String] The base name of the index
    # @return [String] The full index name
    def index_name(name)
      env = Rails.env
      "loco_motion_#{env}_#{name}"
    end

    # Default settings for Algolia indices.
    #
    # @return [Hash] Default index settings
    def default_index_settings
      {
        searchableAttributes: [
          'title',
          'group',
          'helper_names',
          'description',
          'example_code'
        ],
        attributesForFaceting: [
          'filterOnly(group)'
        ],
        customRanking: [
          'desc(popularity)',
          'asc(title)'
        ],
        highlightPreTag: '<em class="highlight">',
        highlightPostTag: '</em>'
      }
    end
  end
end
