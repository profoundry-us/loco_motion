# frozen_string_literal: true

# Helper for Algolia search integration
module AlgoliaHelper
  # Generate JavaScript tag that injects Algolia credentials as window variables
  def algolia_credentials_tag
    # Use raw JavaScript content instead of javascript_tag helper
    env = ENV['ALGOLIA_ENV'] || Rails.env
    content = <<-JS
      <script type="text/javascript">
        window.algoliaCredentials = {
          appId: '#{ENV.fetch('ALGOLIA_APPLICATION_ID', nil)}',
          apiKey: '#{ENV.fetch('ALGOLIA_API_KEY', nil)}',
          indexName: "loco_motion_#{env}_components_#{LocoMotion::VERSION}"
        };
      </script>
    JS

    content.html_safe
  end
end
