class Spud::Admin::PostsController < Spud::Admin::ApplicationController

	layout 'spud/admin/post'
	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :edit, :update, :destroy]
	add_breadcrumb 'Posts', :spud_admin_posts_path

	belongs_to_spud_app :posts

	def index
		@posts = SpudPost.order('published_at desc').includes(:comments).paginate(:page => params[:page], :per_page => 15)
		respond_with @posts
	end

	def show
		respond_with @post
	end

	def edit
		respond_with @post
	end

	def update
    flash[:notice] = 'Post was successfully updated.' if @post.update_attributes(params[:spud_post])
    respond_with @post, :location => spud_admin_posts_path
	end

	def new
		@post = SpudPost.new(:published_at => Date.today)
		respond_with @post
	end

	def create
		@post = SpudPost.new(params[:spud_post])
    flash[:notice] = 'Post was successfully created.' if @post.save
    respond_with @post, :location => spud_admin_posts_path
	end

	def destroy
    flash[:notice] = 'Post was successfully deleted.' if @post.destroy
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

end