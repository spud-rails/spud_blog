class Spud::Admin::PostCommentsController < Spud::Admin::ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_comment, :only => [:show, :edit, :update, :destroy]

	def index
		if params[:post_id]
			@post_comments = SpudPost.find(params[:post_id]).comments
		else
			@post_comments = SpudPost.all
		end
		respond_with @post_comments
	end

	def show
		respond_with @post_comment
	end

	def edit
		respond_with @post_comment
	end

	def update
		
	end

	def create

	end

	def destroy

	end

	private

	def find_comment
		@post_comment = SpudPostComment.find(params[:id])
	end

end