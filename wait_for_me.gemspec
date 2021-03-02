$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "wait_for_me/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "wait_for_me"
  spec.version     = WaitForMe::VERSION
  spec.authors     = ["Perry Hertler"]
  spec.email       = ["perry@hertler.org"]
  spec.homepage    = "https://github.com/g5search/wait_for_me"
  spec.summary     = "Run an operation after waiting for x amount of time or after y related things have occurred"
  spec.description = "Use when the same operation must be run for related activities inside a set amount of time"
  spec.license     = "MIT"



  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_runtime_dependency "rails"
  spec.add_runtime_dependency "pg"
  spec.add_runtime_dependency "sidekiq"

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec-sidekiq'
  spec.add_development_dependency 'shoulda-matchers'
end
