class NewsController < ApplicationController

	respond_to :html, :xml, :json, :rss
	layout Spud::Blog.news_layout

  caches_action :show, :index,
    :expires => Spud::Blog.config.action_caching_duration,
    :if => Proc.new{ |c|
      Spud::Blog.config.enable_action_caching && !(c.params[:page] && c.params[:page].to_i > 1) && (SpudPost.where(:is_news => true).future_posts.count == 0)
    }

  after_filter :only => [:show, :index] do |c|
    if Spud::Blog.enable_full_page_caching && !(c.params[:page] && c.params[:page].to_i > 1)
      if (SpudPost.where(:is_news => true).future_posts.count == 0)
        c.cache_page(nil, nil, false)
      end
    end
  end

  cache_sweeper :spud_post_comment_sweeper, :only => [:create_comment]

  def index
    @posts = SpudPost.public_news_posts(params[:page], Spud::Blog.config.posts_per_page)
    if Spud::Core.config.multisite_mode_enabled
      @posts = @posts.for_spud_site(current_site_id)
    end 
    respond_with @posts
  end

  # The sole purpose of this action is to redirect from a POST to an seo-friendly url
  def filter
    if !params[:category_url_name].blank? && !params[:archive_date].blank?
      redirect_to news_category_archive_path(params[:category_url_name], params[:archive_date])
    elsif !params[:category_url_name].blank?
      redirect_to news_category_path(params[:category_url_name])
    elsif !params[:archive_date].blank?
      redirect_to news_archive_path(params[:archive_date])
    else
      redirect_to news_path
    end
  end

  def category
    if @post_category = SpudPostCategory.find_by_url_name(params[:category_url_name])
      if Spud::Core.config.multisite_mode_enabled
        @posts = @post_category.posts_with_children.public_news_posts(params[:page], Spud::Blog.config.posts_per_page).for_spud_site(current_site_id).from_archive(params[:archive_date])
      else
        @posts = @post_category.posts_with_children.public_news_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:archive_date])
      end
    else
      redirect_to news_path
      return
    end
    respond_with @posts do |format|
      format.html { render 'index' }
    end
  end

  def archive
    if Spud::Core.config.multisite_mode_enabled
      @posts = SpudPost.public_news_posts(params[:page], Spud::Blog.config.posts_per_page).for_spud_site(current_site_id).from_archive(params[:archive_date])
    else
      @posts = SpudPost.public_news_posts(params[:page], Spud::Blog.config.posts_per_page).from_archive(params[:archive_date])
    end
    respond_with @posts do |format|
      format.html { render 'index' }
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