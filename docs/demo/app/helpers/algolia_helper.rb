# frozen_string_literal: true

# Helper for Algolia search integration
module AlgoliaHelper
  # Generate JavaScript tag that injects Algolia credentials as window variables
  #
  # This tag is rendered on every public page, so it must only ever expose the
  # search-only key (ALGOLIA_SEARCH_API_KEY). The write-capable ALGOLIA_API_KEY
  # is reserved for server-side indexing and must never be rendered here.
  def algolia_credentials_tag
    # Use raw JavaScript content instead of javascript_tag helper
    env = ENV["ALGOLIA_ENV"] || Rails.env
    content = <<-JS
      <script type="text/javascript">
        window.algoliaCredentials = {
          appId: '#{ENV.fetch('ALGOLIA_APPLICATION_ID', nil)}',
          apiKey: '#{ENV.fetch('ALGOLIA_SEARCH_API_KEY', nil)}',
          indexName: "loco_motion_#{env}_components_#{LocoMotion::VERSION}"
        };
      </script>
    JS

    raw(content)
  end
end
