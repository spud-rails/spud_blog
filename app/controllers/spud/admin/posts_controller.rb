class Spud::Admin::PostsController < Spud::Admin::ApplicationController

	layout 'spud/admin/post'
	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :edit, :update, :destroy]
	add_breadcrumb 'Blog Posts', :spud_admin_posts_path

	belongs_to_spud_app :blog_posts

	def index
		@posts = SpudPost.where(:is_news => false).order('published_at desc').includes(:comments, :author).paginate(:page => params[:page], :per_page => 15)
		respond_with @posts
	end

	def edit
		@categories = SpudPostCategory.grouped
		respond_with @post
	end

	def update
		@categories = SpudPostCategory.grouped
		if @post.update_attributes(params[:spud_post])
			flash[:notice] = 'Post was successfully updated.'
			expire_blog_actions
		end
    respond_with @post, :location => spud_admin_posts_path
	end

	def new
		@categories = SpudPostCategory.grouped
		@post = SpudPost.new(:published_at => Date.today, :spud_user_id => current_user.id)
		respond_with @post
	end

	def create
		@categories = SpudPostCategory.grouped
		@post = SpudPost.new(params[:spud_post])
		if @post.save
	    flash[:notice] = 'Post was successfully created.'
	    expire_blog_actions
		end
    respond_with @post, :location => spud_admin_posts_path
	end

	def destroy
		if @post.destroy
	    flash[:notice] = 'Post was successfully deleted.' 
	    expire_blog_actions
   	end
    respond_with @post, :location => spud_admin_posts_path
	end

	private

	def find_post
		@post = SpudPost.find(params[:id])
		if @post.blank?
			flash[:error] = "Post not found!"
			redirect_to spud_admin_posts_path and return false
		end
	end

	def expire_blog_actions
		expire_action blog_url
		expire_action blog_post_url(@post.url_name) unless @post.nil?
	end

end