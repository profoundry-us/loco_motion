# frozen_string_literal: true

# This initializer configures the Algolia search integration for LocoMotion.
# You need to set the following environment variables:
# - ALGOLIA_APPLICATION_ID: Your Algolia application ID
# - ALGOLIA_API_KEY: Your Algolia API key (write access for indexing, read-only for search)

if defined?(Rails) && defined?(Algolia)
  # Only attempt to configure if we have credentials
  if ENV['ALGOLIA_APPLICATION_ID'].present? && ENV['ALGOLIA_API_KEY'].present?
    Algolia.init(
      application_id: ENV['ALGOLIA_APPLICATION_ID'],
      api_key: ENV['ALGOLIA_API_KEY']
    )
    
    Rails.logger.info "Algolia search initialized with application ID: #{ENV['ALGOLIA_APPLICATION_ID']}"
  else
    Rails.logger.warn "Algolia search not configured. Set ALGOLIA_APPLICATION_ID and ALGOLIA_API_KEY environment variables."
  end
end
