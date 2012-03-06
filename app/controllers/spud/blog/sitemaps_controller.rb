class Spud::Blog::SitemapsController < Spud::ApplicationController
	respond_to :xml
	caches_action :show, :expires_in => 1.day, :if => Proc.new{ |c| Spud::Blog.config.enable_action_caching }
	caches_page :show, :if => Proc.new{ |c| Spud::Blog.config.enable_full_page_caching }
	def show
		@posts = SpudPost.publicly.all
		respond_with @pages
	end
end
