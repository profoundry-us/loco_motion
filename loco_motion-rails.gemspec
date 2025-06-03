require_relative "lib/loco_motion/version"

Gem::Specification.new do |s|
  s.name        = "loco_motion-rails"
  s.version     = LocoMotion::VERSION
  s.summary     = "Ruby on Rails, loco fast!"
  s.description = "Advanced components and Rails management with LocoMotion."
  s.authors     = ["Topher Fangio"]
  s.email       = "topher@profoundry.us"
  s.homepage    = "https://rubygems.org/gems/loco_motion-rails"
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"

  s.files = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + %w[README.md LICENSE] # Add CHANGELOG.md later
  s.require_paths = ["lib", "app"]

  # Add our few dependencies
  s.add_dependency 'haml-rails', '~> 2.1'
  s.add_dependency 'rails_heroicon', '~> 2.3.0'
  s.add_dependency 'rails', '>= 6.1', '< 8.1'
  s.add_dependency 'view_component', '~> 3.22'

  # Add some things that are no longer part of the standard Ruby distribution
  s.add_dependency 'base64', '~> 0.2.0'
  s.add_dependency 'bigdecimal', '~> 3.1.8'
  s.add_dependency 'drb', '~> 2.2.1'
  s.add_dependency 'fiddle', '~> 1.1.4'
  s.add_dependency 'logger', '~> 1.6.1'
  s.add_dependency 'mutex_m', '~> 0.2.0'
  s.add_dependency 'ostruct', '~> 0.6.0'
  s.add_dependency 'rdoc', '~> 6.7.0'

  # Add our development dependencies
  s.add_development_dependency 'capybara', '~> 3.40'
  s.add_development_dependency 'combustion', '~> 1.3'
  s.add_development_dependency 'rails_heroicon', '~> 2.3.0'
  s.add_development_dependency 'pry', '~> 0.15.0'
  s.add_development_dependency 'rails', '>= 6.1', '< 8.0'
  s.add_development_dependency 'redcarpet', '~> 3.6'
  s.add_development_dependency 'rspec', '~> 3.13.0'
  s.add_development_dependency 'rspec-rails', '~> 6.1.1'
  s.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  s.add_development_dependency 'webrick', '~> 1.8.1'
  s.add_development_dependency 'yard', '~> 0.9.34'
  s.add_development_dependency 'algoliasearch-rails', '~> 2.2'
end
