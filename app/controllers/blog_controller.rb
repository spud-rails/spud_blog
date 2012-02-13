class BlogController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show]
	layout Spud::Blog.base_layout

  def index
    @posts = SpudPost.public_blog_posts(params[:page], Spud::Blog.config.posts_per_page)
    respond_with @posts
  end

  def category
    @post_category = SpudPostCategory.find_by_url_name(params[:category_url_name])
    if @post_category.nil?
      redirect_to blog_path
    else
      if request.post?
        redirect_to blog_category_path(params[:category_url_name])
      else
        @posts = @post_category.posts_with_children.public_blog_posts(params[:page], params[:per_page])
        respond_with @posts do |format|
          format.html { render 'index' }
        end
      end
    end
  end

  def archive
    if request.post?
      redirect_to blog_archive_path(params[:blog_archive])
    else
      @posts = SpudPost.public_blog_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:blog_archive])
      respond_with @posts do |format|
        format.html { render 'index' }
      end
    end
  end

  def show
    if @post.comments_enabled
      @comment = SpudPostComment.new(:spud_post_id => params[:id])
    end
  	respond_with @post
  end

  def create_comment
    return unless params[:comment_validation].empty? # trap spam bots
    @post = SpudPost.find(params[:id])
    if @post.blank?
      flash[:error] = "Post not found!"
      redirect_to blog_path and return false
    end
    @comment = @post.comments.new(params[:spud_post_comment])
    flash[:notice] = 'Your comment has been posted, however it will not appear until it is approved.' if @comment.save
    respond_with @comment do |format|
    	format.html { redirect_to blog_post_path(@post.url_name, :anchor => 'spud_post_comment_form') }
    end
  end 

  private 

  def find_post
  	@post = SpudPost.find_by_url_name(params[:id])
		if @post.blank? || @post.is_private?
			flash[:error] = "Post not found!"
			redirect_to blog_path and return false
		end
  end

end