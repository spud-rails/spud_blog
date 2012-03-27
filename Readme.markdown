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
		