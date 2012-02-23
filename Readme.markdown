Spud Blog
========

Spud Blog is a Blog Engine designed to be robust, easy to use, and light weight.

__NOTE:__ This project is still in its early infancy.

Installation/Usage
------------------

1. In your Gemfile add the following

		gem 'spud_core', :git => "git://github.com/davydotcom/spud_core_admin.git"
		gem 'spud_blog', :git => "git://github.com/davydotcom/spud_blog.git"

2. Run bundle install
3. Copy in database migrations to your new rails project

		bundle exec rake spud_core:install:migrations
		bundle exec rake spud_blog:install:migrations
		rake db:migrate

4. run a rails server instance and point your browser to /spud/admin

Configuration
-------------

Spud Blog current accepts the following configuration options.

	Spud::Blog.configure do |config|
	  config.base_layout = 'blog'
	  config.blog_enabled = true
	  config.news_enabled = true
	  config.blog_path = 'blog'
	  config.news_path = 'news'
	  config.posts_per_page = 5
	end

Customizing Views
-----------------

A number of built-in views have been provided to help you get started with the frontend display. Customzing these views will require you to copy them into your local application, which can be accomplished by using the views generator. 

	rails generate spud:blog:views

__NOTE:__ The built-in views are likely to undergo changes as features are added to the blogging engine. If a new version of Spud Blog does not play nicely with your customized views, try backing up your views to an alternate location and running the views generator again to see what has changed. 