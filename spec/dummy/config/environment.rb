# Load the rails application
require File.expand_path('../application', __FILE__)

Spud::Blog.configure do |config|
	config.news_enabled = true
	config.news_layout = 'application'
end

# Initialize the rails application
Dummy::Application.initialize!
