Spud Blog
========

Spud Blog is a Blog Engine designed to be robust, easy to use, and light weight.

__NOTE:__ This project is still in its early infancy.

## Installation/Usage

1. In your Gemfile add the following

		gem 'spud_core'
		gem 'spud_blog'

2. Run bundle install
3. Copy in database migrations to your new rails project

		bundle exec rake railties:install:migrations
		rake db:migrate

4. run a rails server instance and point your browser to /spud/admin

## Configuration

Spud Blog current accepts the following configuration options.

	Spud::Blog.configure do |config|
	  config.base_layout = 'blog'
	  config.blog_enabled = true
	  config.news_enabled = true
	  config.blog_path = 'blog'
	  config.news_path = 'news'
	  config.posts_per_page = 5
	  config.has_custom_fields = true
	  config.caching_enabled = true
	  config.caching_expires_in = 1.hour
	end

## Customizing Views

A number of built-in views have been provided to help you get started with the frontend display. Customzing these views will require you to copy them into your local application, which can be accomplished by using the views generator.

	rails generate spud:blog:views

__NOTE:__ The built-in views are likely to undergo changes as features are added to the blogging engine. If a new version of Spud Blog does not play nicely with your customized views, try backing up your views to an alternate location and running the views generator again to see what has changed.

## Javascript Driver

Spud Blog includes a small, unobtrusive javascript driver that adds functionality to the built-in views. Including the driver is optional, as all client-side views and controllers are designed to work whether you include it or not.

	<%= javascript_include_tag 'spud/blog' %>

## Custom Fields

You may find that your blog requires a field that isn't included in the default `spud_post` model. Adding custom fields is easy.

1. Set `has_custom_fields` to true in your Spud Blog configuration
2. Create a migration adding the necessary column(s) to your database

		class AddCaptionToPosts < ActiveRecord::Migration
		  def change
		    add_column :spud_posts, :caption, :string
		  end
		end

3. Save a view partial at `app/views/spud/admin/posts/_custom_fields.html.erb` with the desired inputs


		  <div class="control-group">
		    <%= f.label :caption, 'Caption',:class => "control-label" %>
		    <div class="controls">
		    	<%= f.text_field :caption %>
		    </div>
		  </div>

## Extending the Post Model

Rails engines allow you to extend or even completely override classes by adding them to your local application. Source files found in your local app's path will take precedence over those found within the Spud Blog gem. Lets say you wanted to extend the SpudPost model.

1. Create a file at `app/models/spud_post.rb`
2. Add the following code:

		# Use this helper method to pull in the SpudPost source code from the engine
		Spud::Blog::Engine.require_model('spud_post')

		# Add your own methods to SpudPost
		class SpudPost
			attr_accessible :caption
			def byline
				return "'#{self.title}' was posted by #{self.author.full_name} on #{self.display_date}"
			end
		end

## Akismet Support

Spud Blog Engine now supports spam comment filtering using akismet. All you have to do is configure the rakismet gem and enable_rakismet in the spud_blog configuration. Add the following to your application.rb file

    Spud::Blog.configure do |config|
        config.enable_rakismet = true
    end
    config.rakismet.key = "your key here"
    config.rakismet.url = 'http://yourdomain.com/'

Also make sure to add the rakismet gem to your gemfile

		gem 'rakismet'

Testing
-----------------

Spud uses RSpec for testing. Get the tests running with a few short commands:

1. Create and migrate the databases:

        rake db:create
        rake db:migrate

2. Load the schema in to the test database:

        rake app:db:test:prepare

3. Run the tests with RSpec

        rspec spec

After the tests have completed the current code coverage stats is available by opening ```/coverage/index.html``` in a browser.
