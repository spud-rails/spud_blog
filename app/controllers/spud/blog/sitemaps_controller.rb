class Spud::Blog::SitemapsController < Spud::ApplicationController
	respond_to :xml
	def show
		@posts = SpudPost.publicly.all
		respond_with @pages
	end
end
