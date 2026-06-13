# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LocoDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Drop `vendor` from the load path. Rails adds `vendor` to `$LOAD_PATH` by
    # default, but ours holds only the `loco_motion-rails` symlink, which points
    # back at the repo root (so the demo can use the gem via Bundler's `path:`).
    # That makes `vendor` a self-referential directory cycle
    # (vendor/loco_motion-rails -> repo -> docs/demo/vendor/loco_motion-rails ->
    # ...). Bootsnap's path scanner follows the symlink and recurses until the
    # boot crashes with `SystemStackError`. Bundler already adds the gem's own
    # `lib`/`app` require paths, so nothing requireable lives in `vendor` and
    # skipping it is safe.
    config.paths["vendor"].skip_load_path!

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Setup our demo app configuration options
    docs_host = ENV.fetch("LOCO_DOCS_HOST", "http://localhost:8808")
    docs_path = docs_host.include?("localhost") ? "docs" : "v#{LocoMotion::VERSION}"

    config.api_docs_host = "#{docs_host}/#{docs_path}"
  end
end
