Spud Blog
========

Spud Blog is a Blog Engine designed to be robust, easy to use, and light weight.
NOTE: This project is still in its early infancy.

Installation/Usage
------------------

1. In your Gemfile add the following

		gem 'spud_admin', :git => "git://github.com/davydotcom/spud_core_admin.git"
		gem 'spud_blog', :git => "git://github.com/davydotcom/spud_blog.git"

2. Run bundle install
3. Copy in database migrations to your new rails project

		bundle exec rake spud_core:install:migrations
		bundle exec rake spud_blog:install:migrations
		rake db:migrate

4. run a rails server instance and point your browser to /spud/admin

Setting a Layout
----------------

The blog will default to your `application` layout. To set a custom one, add the following to your environment file:

	Spud::Blog.configure do |config|
  	config.default_layout = 'blog'
	end

Customizing Routes & Views
-------------------------

A number of starter views have been provided for you as a jumping off point. You may choose to use these views or write your own from scratch. When displaying a post make sure to respect the individual post's `comments_enabled` flag. 

Routes are currently hard-coded at the engine level, though the ability to customize your blog routes may be a feature at some point in the future. 