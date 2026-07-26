# frozen_string_literal: true

# This initializer sets up the PostHog analytics client for the LocoMotion
# demo application. Set the following environment variables:
# - POSTHOG_PROJECT_TOKEN: Your PostHog project API key
# - POSTHOG_HOST: Your PostHog host (default: https://us.i.posthog.com)

require "posthog"

if ENV["POSTHOG_PROJECT_TOKEN"].present?
  POSTHOG_CLIENT = PostHog::Client.new(
    api_key: ENV["POSTHOG_PROJECT_TOKEN"],
    host: ENV.fetch("POSTHOG_HOST", "https://us.i.posthog.com"),
    on_error: proc { |status, msg| Rails.logger.error("PostHog error: #{status} - #{msg}") }
  )

  Rails.logger.info "PostHog analytics initialized."
else
  POSTHOG_CLIENT = nil

  Rails.logger.warn(
    "POSTHOG_PROJECT_TOKEN variable required by PostHog is missing or un-configured, " \
    "this causes events to be silently missed. " \
    "This error stops appearing once POSTHOG_PROJECT_TOKEN is configured"
  )
end
