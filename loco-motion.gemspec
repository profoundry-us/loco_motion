Gem::Specification.new do |s|
  s.name        = "loco-motion"
  s.version     = "0.0.1"
  s.summary     = "Ruby on Rails, loco fast!"
  s.description = "Advanced components and Rails management with LocoMotion."
  s.authors     = ["Topher Fangio"]
  s.email       = "topher@profoundry.us"
  s.homepage    = "https://rubygems.org/gems/loco-motion"
  s.license     = "MIT"

  s.files = Dir.glob("lib/**/*") + %w[README.md LICENSE] # Add CHANGELOG.md later
  s.require_paths = ["lib"]

  # Add our few dependencies
  s.add_dependency 'view_component', '~> 3.10'
end
