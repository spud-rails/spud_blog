class BlogController < ApplicationController

	respond_to :html, :xml, :json, :rss
	layout Spud::Blog.base_layout

  before_filter :find_post, :only => :show

  caches_action :show, :index,
    :expires => Spud::Blog.config.action_caching_duration,
    :if => Proc.new{ |c|
      Spud::Blog.config.enable_action_caching && !(c.params[:page] && c.params[:page].to_i > 1) && (SpudPost.where(:is_news => false).future_posts.count == 0)
    }

  after_filter :only => [:show, :index] do |c|
    if Spud::Blog.enable_full_page_caching && !(c.params[:page] && c.params[:page].to_i > 1)
      if (SpudPost.where(:is_news => false).future_posts.count == 0)
        c.cache_page(nil, nil, false)
      end
    end
  end

  cache_sweeper :spud_post_comment_sweeper, :only => [:create_comment]

  def index
    @posts = SpudPost.public_blog_posts(params[:page], Spud::Blog.config.posts_per_page)
    respond_with @posts
  end

  # The sole purpose of this action is to redirect from a POST to an seo-friendly url
  def filter
    if !params[:category_url_name].blank? && !params[:archive_date].blank?
      redirect_to blog_category_archive_path(params[:category_url_name], params[:archive_date])
    elsif !params[:category_url_name].blank?
      redirect_to blog_category_path(params[:category_url_name])
    elsif !params[:archive_date].blank?
      redirect_to blog_archive_path(params[:archive_date])
    else
      redirect_to blog_path
    end
  end

  def category
    if @post_category = SpudPostCategory.find_by_url_name(params[:category_url_name])
      @posts = @post_category.posts_with_children.public_blog_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:archive_date])
    else
      redirect_to blog_path
      return
    end
    respond_with @posts do |format|
      format.html { render 'index' }
    end
  end

  def archive
    @posts = SpudPost.public_blog_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:archive_date])
    respond_with @posts do |format|
      format.html { render 'index' }
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
    @comment.approved = true
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