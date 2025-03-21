$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "front_end_builds/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "front_end_builds"
  s.version     = FrontEndBuilds::VERSION
  s.authors     = ["Ryan Toronto", "Sam Selikoff"]
  s.email       = ["rt@ted.com", "sam@ted.com"]
  s.homepage    = "http://github.com/tedconf/front_end_builds"
  s.summary     = "Summary of FrontEndBuilds."
  s.description = "Rails engine to manage front end builds and deployments"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,public}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "sqlite3", "2.0.1"
  s.add_development_dependency 'rspec-rails', '6.1.2'
  s.add_development_dependency 'rspec-its', '1.3.0'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'debug', '~> 1.9'
  s.add_development_dependency 'shoulda-matchers', '6.2.0'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rexml'
  s.add_development_dependency 'database_cleaner-active_record'
end
