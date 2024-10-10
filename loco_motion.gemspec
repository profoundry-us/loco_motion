Gem::Specification.new do |s|
  s.name        = "loco_motion"
  s.version     = "0.0.4"
  s.summary     = "Ruby on Rails, loco fast!"
  s.description = "Advanced components and Rails management with LocoMotion."
  s.authors     = ["Topher Fangio"]
  s.email       = "topher@profoundry.us"
  s.homepage    = "https://rubygems.org/gems/loco_motion"
  s.license     = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + %w[README.md LICENSE] # Add CHANGELOG.md later
  s.require_paths = ["lib", "app"]

  # Add our few dependencies
  s.add_dependency 'haml-rails', '~> 2.1'
  s.add_dependency 'heroicons-rails', '~> 1.2'
  s.add_dependency 'rails', '>= 6.1'
  s.add_dependency 'view_component', '~> 3.14'

  # Add some things that are no longer part of the standard Ruby distribution
  s.add_dependency 'base64'
  s.add_dependency 'bigdecimal'
  s.add_dependency 'fiddle'
  s.add_dependency 'logger'
  s.add_dependency 'mutex_m'
  s.add_dependency 'ostruct'
  s.add_dependency 'rdoc'

  # Add our development dependencies
  s.add_development_dependency 'capybara', '~> 3.40'
  s.add_development_dependency 'combustion', '~> 1.3'
  s.add_development_dependency 'heroicons-rails', '~> 1.2'
  s.add_development_dependency 'rails', '~> 6.1'
  s.add_development_dependency 'redcarpet', '~> 3.6'
  s.add_development_dependency 'rspec', '~> 3.13.0'
  s.add_development_dependency 'rspec-rails', '~> 6.1.1'
  s.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  s.add_development_dependency 'webrick', '~> 1.8.1'
  s.add_development_dependency 'yard', '~> 0.9.34'
end
