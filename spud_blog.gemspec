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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "Readme.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency 'spud_core', ">= 0.10.0"
  s.add_dependency 'spud_permalinks', "~>0.9.0"
  s.add_dependency 'truncate_html'
  s.add_dependency 'awesome_nested_set'

  s.add_development_dependency 'mysql2', '0.3.11'
  s.add_development_dependency 'rspec', '2.8.0'
  s.add_development_dependency 'rspec-rails', '2.8.1'
  s.add_development_dependency 'shoulda', '~> 3.0.1'
  s.add_development_dependency 'factory_girl', '2.5.0'
  s.add_development_dependency 'mocha', '0.10.3'
  s.add_development_dependency 'database_cleaner', '0.7.1'
  s.add_development_dependency 'simplecov', '~> 0.6.4'
end
