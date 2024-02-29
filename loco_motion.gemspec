Gem::Specification.new do |s|
  s.name        = "loco_motion"
  s.version     = "0.0.3"
  s.summary     = "Ruby on Rails, loco fast!"
  s.description = "Advanced components and Rails management with LocoMotion."
  s.authors     = ["Topher Fangio"]
  s.email       = "topher@profoundry.us"
  s.homepage    = "https://rubygems.org/gems/loco_motion"
  s.license     = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + %w[README.md LICENSE] # Add CHANGELOG.md later
  s.require_paths = ["lib", "app"]

  # Add our few dependencies
  s.add_dependency 'rails', '~> 6.1'
  s.add_dependency 'view_component', '~> 3.10'

  # Add our development dependencies
  s.add_development_dependency 'webrick', '~> 1.8.1'
  s.add_development_dependency 'yard', '~> 0.9.34'
end
