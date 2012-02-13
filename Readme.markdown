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

A number of starter views have been provided for you as a jumping off point. You may choose to use these views or write your own from scratch. When displaying a post make sure to respect the individual post's `comments_enabled` flag. 