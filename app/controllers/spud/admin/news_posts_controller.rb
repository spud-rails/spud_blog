class Spud::Admin::NewsPostsController < Spud::Admin::ApplicationController

	layout 'spud/admin/detail'
	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :edit, :update, :destroy]
	add_breadcrumb 'News Posts', {:action => :index}
	add_breadcrumb "New", '',:only =>  [:new, :create]
	add_breadcrumb "Edit", '',:only => [:edit, :update]
	belongs_to_spud_app :news_posts
	cache_sweeper :spud_post_sweeper, :only => [:create, :update, :destroy]

	def index
		@posts = SpudPost.where(:is_news => true).order('published_at desc').includes(:comments).paginate(:page => params[:page], :per_page => 15)
		respond_with @posts
	end

	def edit
		@categories = SpudPostCategory.grouped
		respond_with @post
	end

	def update
		@categories = SpudPostCategory.grouped
		params[:spud_post][:spud_site_ids] ||= []
		if @post.update_attributes(params[:spud_post])
	    flash[:notice] = 'News Post was successfully updated.'
		end
    respond_with @post, :location => spud_core.admin_news_posts_path
	end

	def new
		@categories = SpudPostCategory.grouped
		@post = SpudPost.new(:published_at => Time.zone.now, :spud_user_id => current_user.id, :is_news => true, :comments_enabled => false, :spud_site_ids => [current_site_id])
		respond_with @post
	end

	def create
		@categories = SpudPostCategory.grouped
		params[:spud_post][:spud_site_ids] ||= []
		@post = SpudPost.new(params[:spud_post])
		if @post.save
    	flash[:notice] = 'News Post was successfully created.'
		end
    respond_with @post, :location => spud_core.admin_news_posts_path
	end

	def destroy
		if @post.destroy
	    flash[:notice] = 'News Post was successfully deleted.'
		end
    respond_with @post, :location => spud_core.admin_news_posts_path
	end

	private

	def find_post
		@post = SpudPost.find(params[:id])
		if @post.blank?
			flash[:error] = 'News Post not found!'
			redirect_to spud_core.admin_news_posts_path and return false
		end
	end

end
