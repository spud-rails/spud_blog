

class Spud::Admin::PostsController < Spud::Admin::ApplicationController

	layout 'spud/admin/detail'
	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :edit, :update, :destroy]
	add_breadcrumb 'Blog Posts', :spud_admin_posts_path
	belongs_to_spud_app :blog_posts

	def index
		@posts = SpudPost.where(:is_news => false).order('published_at desc').includes(:visible_comments, :spam_comments, :author).paginate(:page => params[:page], :per_page => 15)
		respond_with @posts
	end

	def edit
		@categories = SpudPostCategory.grouped
		respond_with @post
	end

	def update
		@categories = SpudPostCategory.grouped
		params[:spud_post][:spud_site_ids] ||= []
		if @post.update_attributes(post_params)
			flash[:notice] = 'Post was successfully updated.'
		end
    respond_with @post, :location => spud_admin_posts_path
	end

	def new
		@categories = SpudPostCategory.grouped
		@post = SpudPost.new(:published_at => Time.zone.now, :spud_user_id => current_user.id, :spud_site_ids => [session[:admin_site] || 0])
		respond_with @post
	end

	def create
		@categories = SpudPostCategory.grouped
		params[:spud_post][:spud_site_ids] ||= []
		@post = SpudPost.new(post_params)
		if @post.save
	    flash[:notice] = 'Post was successfully created.'
		end
    respond_with @post, :location => spud_admin_posts_path
	end

	def destroy
		if @post.destroy
	    flash[:notice] = 'Post was successfully deleted.'
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


	def post_params
		allowed_params = [:is_news,:published_at,:title,:content,:spud_user_id,:url_name,:visible,:comments_enabled,:meta_keywords,:meta_description,{:category_ids => []}, {:spud_site_ids => []}, :content_format]
		if Spud::Blog.config.custom_fields
			allowed_params.concat(Spud::Blog.config.custom_fields)
		end
		params.require(:spud_post).permit *allowed_params
	end

end
