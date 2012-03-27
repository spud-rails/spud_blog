$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spud_blog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spud_blog"
  s.version     = Spud::Blog::VERSION
  s.authors     = ["Greg Woods"]
  s.email       = ["greg@westlakedesign.com"]
  s.homepage    = "http://github.com/davydotcom/spud_blog"
  s.summary     = "Spud Blog Engine."
  s.description = "Spud blogging/news and rss engine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency 'spud_core', ">= 0.8.0", "< 0.9.0"
  s.add_dependency 'spud_permalinks', "~>0.0.1"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl', '2.5.0'
  s.add_development_dependency 'mocha', '0.10.3'
  s.add_development_dependency "database_cleaner", "0.7.1"
end
