class Spud::Admin::PostCommentsController < Spud::Admin::ApplicationController

	respond_to :html, :xml, :json
	layout 'spud/admin/detail'
	belongs_to_spud_app :blog_posts
	before_filter :find_comment, :only => [:show, :edit, :update, :destroy, :approve, :spam]
	add_breadcrumb 'Blog Posts', :spud_admin_posts_path
	add_breadcrumb 'Comments', :spud_admin_post_comments_path


	def index
		@page_name = "Comments"
		if params[:post_id]
			@post_comments = SpudPost.find(params[:post_id]).comments
		else
			@post_comments = SpudPostComment
		end
		@post_comments = @post_comments.paginate :page => params[:page]
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

	def approve

		if Spud::Blog.enable_rakismet && @post_comment.spam
			@post_comment.ham!
		end
		@post_comment.update_attributes(:spam => false)
		redirect_to request.referer || spud_admin_post_comments_path
	end

	def spam
		if Spud::Blog.enable_rakismet && !@post_comment.spam
			@post_comment.spam!
		end
		@post_comment.update_attributes(:spam => true)
		redirect_to request.referer || spud_admin_post_comments_path
	end

	def destroy
		if !@post_comment.destroy
			flash[:error] = "Whoops! Something odd happened while trying to delete that comment. Thats not fun. please try again."
		end
		respond_with @post_comment, :location => request.referer || spud_admin_post_comments_path
	end

	private

	def find_comment
		@post_comment = SpudPostComment.find(params[:id])
	end

end
