class Spud::Blog::SitemapsController < Spud::ApplicationController
	respond_to :xml
	caches_action :show, :expires_in => 1.day
	def show
		@posts = SpudPost.publicly.all
		respond_with @pages
	end
end
