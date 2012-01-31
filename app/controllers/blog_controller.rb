class BlogController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :find_post, :only => [:show, :create_comment]
	layout Spud::Blog.base_layout

  def index
    @posts = SpudPost.for_frontend(params[:page], params[:per_page])
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
        @posts = @post_category.posts.for_frontend(params[:page], params[:per_page])
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
      @posts = SpudPost.from_archive(params[:blog_archive]).for_frontend(params[:page], params[:per_page])
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
    @comment = @post.comments.new(params[:spud_post_comment])
    flash[:notice] = 'Your comment has been posted, however it will not appear until it is approved.' if @comment.save
    respond_with @comment do |format|
    	format.html { redirect_to blog_post_path(@post, :anchor => 'spud_post_comment_form') }
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