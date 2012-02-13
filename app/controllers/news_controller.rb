class NewsController < ApplicationController

	respond_to :html, :xml, :json
	layout Spud::Blog.base_layout

  def index
    @posts = SpudPost.public_news_posts(params[:page], Spud::Blog.config.posts_per_page)
    respond_with @posts
  end

  def category
    @post_category = SpudPostCategory.find_by_url_name(params[:category_url_name])
    if @post_category.nil?
      redirect_to news_path
    else
      if request.post?
        redirect_to news_category_path(params[:category_url_name])
      else
        @posts = @post_category.posts.public_news_posts(params[:page], Spud::Blog.config.posts_per_page)
        respond_with @posts do |format|
          format.html { render 'index' }
        end
      end
    end
  end

  def archive
    if request.post?
      redirect_to news_archive_path(params[:archive_date])
    else
      @posts = SpudPost.public_news_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:archive_date])
      respond_with @posts do |format|
        format.html { render 'index' }
      end
    end
  end

  def show
  	@post = SpudPost.find_by_url_name(params[:id])
		if @post.blank? || @post.is_private?
			flash[:error] = "Post not found!"
			redirect_to news_path and return false
		else
			respond_with @post
		end
  end

end